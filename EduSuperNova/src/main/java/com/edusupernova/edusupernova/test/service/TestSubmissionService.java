package com.edusupernova.edusupernova.test.service;

import com.edusupernova.edusupernova.data.TestQuestionsRepository;
import com.edusupernova.edusupernova.data.TestRepository;
import com.edusupernova.edusupernova.test.dto.request.SubmitAnswerRequest;
import com.edusupernova.edusupernova.test.dto.response.AnswerFeedbackDTO;
import com.edusupernova.edusupernova.test.dto.response.TestQuestionDTO;
import com.edusupernova.edusupernova.exception.ForbiddenException;
import com.edusupernova.edusupernova.exception.ResourceNotFoundException;
import com.edusupernova.edusupernova.model.Quiz;
import com.edusupernova.edusupernova.model.TestQuestions;
import com.edusupernova.edusupernova.model.Tests;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Objects;

/**
 * Handles per-question answer submission and the associated evaluation, scoring, and test completion.
 */
@Slf4j
@Service
@RequiredArgsConstructor
@Transactional
public class TestSubmissionService implements ITestSubmissionService {

    private final TestRepository           testRepository;
    private final TestQuestionsRepository  testQuestionsRepository;
    private final OpenEndedEvaluator       openEndedEvaluator;
    private final TestScoringHelper        scoringHelper;
    private final TestMapper               testMapper;

    // ── Submit ────────────────────────────────────────────────────────────────

    @Override
    public AnswerFeedbackDTO submitAnswer(Integer testId, SubmitAnswerRequest request, String email) {
        Tests test = findTest(testId);
        assertOwnership(test, email);
        assertNotExpired(test);

        TestQuestions tq = testQuestionsRepository
                .findByIdTestIdAndIdQuizId(testId, request.quizId())
                .orElseThrow(() -> new IllegalArgumentException(
                        "Question quizId=" + request.quizId() + " not in testId=" + testId));

        Quiz quiz = tq.getQuiz();
        boolean isMCQ = scoringHelper.isMCQType(quiz.getQuestionType());

        String  previousResponse = tq.getUserResponse();
        boolean alreadyAnswered  = tq.getAnsweredAt() != null;
        boolean newResponseBlank = request.userResponse() == null || request.userResponse().isBlank();

        tq.setUserResponse(request.userResponse());

        boolean isCorrect;
        String  aiFeedback;
        Double  aiScore = null;

        if (isMCQ) {
            isCorrect  = scoringHelper.evaluateMCQ(request.userResponse(), quiz.getCorrectAnswer());
            aiFeedback = scoringHelper.generateMCQFeedback(quiz, isCorrect);
        } else {
            if (newResponseBlank) {
                isCorrect  = false;
                aiScore    = 0.0;
                aiFeedback = "No answer was provided for this question.";
                log.info("quizId={} submitted blank — assigning score 0", request.quizId());

            } else if (alreadyAnswered
                    && tq.getAiScore() != null && tq.getAiScore() >= 0
                    && Objects.equals(previousResponse, request.userResponse())) {
                isCorrect  = Boolean.TRUE.equals(tq.getCorrectResponse());
                aiFeedback = tq.getFeedbackIa();
                aiScore    = tq.getAiScore();
                log.debug("quizId={} unchanged re-submission — reusing cached score {}", request.quizId(), aiScore);

            } else {
                try {
                    OpenEndedEvaluator.EvaluationResult result =
                            openEndedEvaluator.evaluateBatch(List.of(tq),
                                    test.getCourse().getExam().getExamname(),
                                    test.getPaper() != null ? test.getPaper().getPaperName() : null).get(0);
                    isCorrect  = result.score() >= 6.0;
                    aiFeedback = result.feedback();
                    aiScore    = result.score();
                } catch (RuntimeException e) {
                    log.warn("AI evaluation failed for quizId={}: {}", request.quizId(), e.getMessage());
                    isCorrect  = false;
                    aiFeedback = "AI feedback unavailable — please review your answer manually.";
                    aiScore    = -1.0;
                }
            }
        }

        tq.setCorrectResponse(isCorrect);
        tq.setFeedbackIa(aiFeedback);
        tq.setAiScore(aiScore);
        tq.setAnsweredAt(LocalDateTime.now());
        testQuestionsRepository.save(tq);

        if (!alreadyAnswered) {
            test.setTotalAnswered(test.getTotalAnswered() + 1);
            if (isCorrect) test.setTotalCorrect(test.getTotalCorrect() + 1);
        }

        List<TestQuestions> allQuestions = testQuestionsRepository.findByIdTestId(testId);
        long unanswered = allQuestions.stream()
                .filter(q -> q.getUserResponse() == null || q.getUserResponse().isBlank())
                .count();
        boolean complete = unanswered == 0;

        if (complete && test.getStatus() != Tests.TestStatus.COMPLETED) {
            completeTest(test, allQuestions);
        }
        testRepository.save(test);

        TestQuestionDTO nextQuestion = null;
        if (!complete) {
            nextQuestion = allQuestions.stream()
                    .filter(q -> q.getUserResponse() == null || q.getUserResponse().isBlank())
                    .findFirst()
                    .map(q -> testMapper.toQuestionDTO(q, testMapper.getQuestionNumber(allQuestions, q)))
                    .orElse(null);
        }

        log.debug("testId={} quizId={} correct={} complete={}", testId, request.quizId(), isCorrect, complete);

        return new AnswerFeedbackDTO(
                quiz.getId(),
                isCorrect,
                quiz.getCorrectAnswer(),
                quiz.getExplanation(),
                aiFeedback,
                aiScore,
                complete,
                nextQuestion
        );
    }

    // ── Legacy batch save ─────────────────────────────────────────────────────

    @Override
    public boolean saveAnswers(Integer testId, List<TestQuestions> userAnswers) {
        try {
            userAnswers.forEach(ua -> {
                if (ua.getId() != null && ua.getId().getQuizId() != null) {
                    testQuestionsRepository
                            .findByIdTestIdAndIdQuizId(testId, ua.getId().getQuizId())
                            .ifPresent(tq -> {
                                tq.setUserResponse(ua.getUserResponse());
                                testQuestionsRepository.save(tq);
                            });
                }
            });
            return true;
        } catch (Exception ex) {
            log.error("saveAnswers failed for testId={}: {}", testId, ex.getMessage());
            return false;
        }
    }

    // ── Private helpers ───────────────────────────────────────────────────────

    private void completeTest(Tests test, List<TestQuestions> allQuestions) {
        List<TestQuestions> needsEval = allQuestions.stream()
                .filter(q -> !scoringHelper.isMCQType(q.getQuiz().getQuestionType()))
                .filter(q -> q.getUserResponse() != null && !q.getUserResponse().isBlank())
                .filter(q -> q.getAiScore() == null || q.getAiScore() < 0)
                .toList();

        if (!needsEval.isEmpty()) {
            log.info("testId={} — evaluating {} unevaluated open-ended question(s) at completion",
                    test.getId(), needsEval.size());
            try {
                List<OpenEndedEvaluator.EvaluationResult> batchResults = openEndedEvaluator.evaluateBatch(
                        needsEval,
                        test.getCourse().getExam().getExamname(),
                        test.getPaper() != null ? test.getPaper().getPaperName() : null);
                for (int i = 0; i < needsEval.size(); i++) {
                    TestQuestions q = needsEval.get(i);
                    OpenEndedEvaluator.EvaluationResult r = batchResults.get(i);
                    q.setCorrectResponse(r.score() >= 6.0);
                    q.setFeedbackIa(r.feedback());
                    q.setAiScore(r.score());
                    q.setAnsweredAt(LocalDateTime.now());
                    testQuestionsRepository.save(q);
                }
            } catch (RuntimeException e) {
                log.warn("testId={} — completion batch evaluation failed: {}", test.getId(), e.getMessage());
            }
        }

        int correctCount = (int) allQuestions.stream()
                .filter(q -> Boolean.TRUE.equals(q.getCorrectResponse()))
                .count();

        test.setTotalCorrect(correctCount);
        test.setTotalAnswered(allQuestions.size());
        test.setStatus(Tests.TestStatus.COMPLETED);
        test.setCompletedAt(LocalDateTime.now());
        test.setFinalScore(scoringHelper.computeFinalScore(correctCount, allQuestions));
    }

    private Tests findTest(Integer testId) {
        return testRepository.findById(testId)
                .orElseThrow(() -> new ResourceNotFoundException("Test not found: " + testId));
    }

    private void assertOwnership(Tests test, String email) {
        if (!test.getUser().getEmail().equals(email)) {
            throw new ForbiddenException("Test does not belong to user: " + email);
        }
    }

    private void assertNotExpired(Tests test) {
        if (scoringHelper.getRemainingSeconds(test) == 0
                && test.getStatus() == Tests.TestStatus.IN_PROGRESS) {
            test.setStatus(Tests.TestStatus.ABANDONED);
            testRepository.save(test);
            throw new IllegalStateException("Test time limit exceeded");
        }
    }
}
