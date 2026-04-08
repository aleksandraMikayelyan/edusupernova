package com.edusupernova.edusupernova.service;

import com.edusupernova.edusupernova.data.TestQuestionsRepository;
import com.edusupernova.edusupernova.model.Quiz;
import com.edusupernova.edusupernova.model.TestQuestions;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.concurrent.CompletableFuture;
import java.util.stream.IntStream;

/**
 * Orchestrates full test evaluation (batch mode — used for legacy endpoints
 * and for re-evaluating completed sessions from the admin panel).
 *
 * For the normal per-question flow, evaluation is handled inside
 * TestService.submitAnswer() instead.
 *
 * CHANGED FROM ORIGINAL:
 *   - OPEN_ENDED_TYPES now includes ESSAY, FILL_IN_BLANK, and READING
 *     to cover IELTS Writing and other new paper formats.
 *   - extractLetter() deduplicated from TestService into a shared static util.
 *   - evaluateTest() signature extended with examName + paperName
 *     (previously examType + sectionName) to match new model naming.
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class EvaluationService {

    // ── Weights ────────────────────────────────────────────────────────────────
    private static final double MC_WEIGHT   = 0.70;
    private static final double OPEN_WEIGHT = 0.30;

    /** Sentinel: score == -1 means AI has not evaluated this row yet. */
    private static final int    PENDING_SCORE    = -1;
    private static final String PENDING_FEEDBACK = "AI evaluation in progress...";

    /**
     * All question types that require AI evaluation.
     * CHANGED: added ESSAY, FILL_IN_BLANK, READING to support new exam formats.
     */
    private static final Set<Quiz.QuestionType> OPEN_ENDED_TYPES = Set.of(
            Quiz.QuestionType.OPEN_ENDED,
            Quiz.QuestionType.LOGICAL_PROBLEMS,
            Quiz.QuestionType.ESSAY,
            Quiz.QuestionType.FILL_IN_BLANK,
            Quiz.QuestionType.READING
    );

    private final TestQuestionsRepository testQuestionRepo;
    private final OpenEndedEvaluator      openEndedEvaluator;

    // ── Public DTOs ────────────────────────────────────────────────────────────

    public record QuestionResult(
            int               questionId,
            String            questionText,
            Quiz.QuestionType type,
            String            userResponse,
            String            correctAnswer,
            boolean           isCorrect,
            String            feedback,
            double            score           // -1.0 == pending
    ) {}

    public record TestEvaluationResult(
            double               mcScore,
            double               openScore,
            double               totalScore,
            boolean              openEndedPending,
            List<QuestionResult> questionResults
    ) {}

    // ── PHASE 1 — Multiple-Choice (synchronous) ────────────────────────────────

    /**
     * Entry point for batch evaluation.
     * Returns instantly with MC results; triggers async AI evaluation if needed.
     *
     * @param testId     the test to evaluate
     * @param examName   e.g. "A Levels"  (was examType)
     * @param paperName  e.g. "Paper 3 - Essays"  (was sectionName)
     */
    @Transactional
    public TestEvaluationResult evaluateTest(Integer testId, String examName, String paperName) {

        List<TestQuestions> allAnswers  = loadAnswers(testId);
        List<TestQuestions> mcAnswers   = filterByNonOpenTypes(allAnswers);
        List<TestQuestions> openAnswers = filterByTypes(allAnswers, OPEN_ENDED_TYPES);

        // Score MC instantly — zero AI involved
        List<QuestionResult> mcResults = evaluateMultipleChoice(mcAnswers);
        persistMultipleChoiceResults(mcAnswers, mcResults);

        double  mcScore      = averageScore(mcResults);
        boolean hasPendingAI = !openAnswers.isEmpty();

        if (hasPendingAI) {
            markOpenEndedAsPending(openAnswers);
            triggerAsyncOpenEndedEvaluation(testId, openAnswers, examName, paperName);
        }

        List<QuestionResult> pendingOpenResults = buildPendingPlaceholders(openAnswers);
        List<QuestionResult> allResults         = mergeResults(mcResults, pendingOpenResults);

        double totalScore = hasPendingAI ? mcScore * MC_WEIGHT : mcScore;

        log.info("Test {} Phase-1 complete — MC score: {}, open-ended pending: {}",
                testId, mcScore, hasPendingAI);

        return new TestEvaluationResult(mcScore, 0.0, totalScore, hasPendingAI, allResults);
    }

    // ── POLLING ────────────────────────────────────────────────────────────────

    public TestEvaluationResult buildResultFromPersistedRows(
            Integer testId,
            List<TestQuestions> answers) {

        List<QuestionResult> results = answers.stream()
                .map(this::toQuestionResult)
                .toList();

        boolean openEndedPending = results.stream()
                .anyMatch(r -> r.score() < 0 || PENDING_FEEDBACK.equals(r.feedback()));

        List<QuestionResult> mcResults   = results.stream()
                .filter(r -> !OPEN_ENDED_TYPES.contains(r.type()))
                .toList();
        List<QuestionResult> openResults = results.stream()
                .filter(r -> OPEN_ENDED_TYPES.contains(r.type()))
                .toList();

        double mcScore   = averageScore(mcResults);
        double openScore = openEndedPending ? 0.0 : averageScore(openResults);
        double total     = openResults.isEmpty()
                ? mcScore
                : mcScore * MC_WEIGHT + openScore * OPEN_WEIGHT;

        return new TestEvaluationResult(mcScore, openScore, total, openEndedPending, results);
    }

    // ── Async AI evaluation ────────────────────────────────────────────────────

    @Async
    public CompletableFuture<Void> triggerAsyncOpenEndedEvaluation(
            Integer testId,
            List<TestQuestions> openAnswers,
            String examName,
            String paperName) {

        try {
            log.info("Test {} — Groq evaluation starting for {} open-ended questions", testId, openAnswers.size());
            String context = String.format("Exam: %s, Paper: %s", examName, paperName);

            List<OpenEndedEvaluator.EvaluationResult> aiResults =
                    openEndedEvaluator.evaluateBatch(openAnswers, context);

            persistOpenEndedResults(openAnswers, aiResults);
            log.info("Test {} — Groq evaluation complete and persisted", testId);

        } catch (Exception ex) {
            log.error("Test {} — Groq evaluation failed (MC results unaffected): {}",
                    testId, ex.getMessage(), ex);
        }

        return CompletableFuture.completedFuture(null);
    }

    // ── MC evaluation ──────────────────────────────────────────────────────────

    private List<QuestionResult> evaluateMultipleChoice(List<TestQuestions> answers) {
        return answers.stream().map(this::scoreOneMultipleChoice).toList();
    }

    private QuestionResult scoreOneMultipleChoice(TestQuestions answer) {
        String userResponse  = extractLetter(answer.getUserResponse());
        String correctAnswer = extractLetter(answer.getQuiz().getCorrectAnswer());

        boolean isCorrect = !userResponse.isBlank()
                && !correctAnswer.isBlank()
                && userResponse.equalsIgnoreCase(correctAnswer);

        double score    = isCorrect ? 10.0 : 0.0;
        String feedback = isCorrect
                ? "Correct!"
                : "Incorrect. The correct answer was: " + correctAnswer;

        return new QuestionResult(
                answer.getQuiz().getId(),
                answer.getQuiz().getQuestionText(),
                answer.getQuiz().getType(),
                answer.getUserResponse(),
                answer.getQuiz().getCorrectAnswer(),
                isCorrect,
                feedback,
                score
        );
    }

    // ── Persistence ────────────────────────────────────────────────────────────

    private void persistMultipleChoiceResults(
            List<TestQuestions> answers,
            List<QuestionResult> results) {
        IntStream.range(0, answers.size()).forEach(i -> {
            TestQuestions  q = answers.get(i);
            QuestionResult r = results.get(i);
            q.setCorrectResponse(r.isCorrect());
            q.setPunctuation(r.isCorrect() ? 10 : 0);
            q.setFeedbackIa(r.feedback());
        });
    }

    private void markOpenEndedAsPending(List<TestQuestions> openAnswers) {
        openAnswers.forEach(q -> {
            q.setPunctuation(PENDING_SCORE);
            q.setFeedbackIa(PENDING_FEEDBACK);
            q.setCorrectResponse(false);
        });
    }

    @Transactional(jakarta.transaction.Transactional.TxType.REQUIRES_NEW)
    public void persistOpenEndedResults(
            List<TestQuestions> answers,
            List<OpenEndedEvaluator.EvaluationResult> aiResults) {
        IntStream.range(0, answers.size()).forEach(i -> {
            TestQuestions q  = answers.get(i);
            var           ai = aiResults.get(i);
            q.setPunctuation((int) Math.round(ai.score()));
            q.setFeedbackIa(ai.feedback());
            q.setCorrectResponse(ai.score() >= 6.0);
        });
    }

    // ── Utility helpers ────────────────────────────────────────────────────────

    private List<TestQuestions> loadAnswers(Integer testId) {
        List<TestQuestions> answers = testQuestionRepo.findByIdTestId(testId);
        if (answers.isEmpty()) throw new IllegalStateException("No answers found for testId: " + testId);
        return answers;
    }

    private List<TestQuestions> filterByTypes(List<TestQuestions> answers, Set<Quiz.QuestionType> types) {
        return answers.stream()
                .filter(a -> a.getQuiz() != null && types.contains(a.getQuiz().getType()))
                .toList();
    }

    private List<TestQuestions> filterByNonOpenTypes(List<TestQuestions> answers) {
        return answers.stream()
                .filter(a -> a.getQuiz() != null && !OPEN_ENDED_TYPES.contains(a.getQuiz().getType()))
                .toList();
    }

    private QuestionResult toQuestionResult(TestQuestions row) {
        Quiz              quiz = row.getQuiz();
        Quiz.QuestionType type = quiz != null ? quiz.getType() : Quiz.QuestionType.MULTIPLE_CHOICE;

        int    storedScore = row.getPunctuation() != null ? row.getPunctuation() : PENDING_SCORE;
        String feedback    = row.getFeedbackIa()  != null ? row.getFeedbackIa()  : PENDING_FEEDBACK;

        return new QuestionResult(
                quiz != null ? quiz.getId()           : 0,
                quiz != null ? quiz.getQuestionText() : "",
                type,
                row.getUserResponse(),
                quiz != null ? quiz.getCorrectAnswer() : "",
                Boolean.TRUE.equals(row.getCorrectResponse()),
                feedback,
                storedScore
        );
    }

    private List<QuestionResult> buildPendingPlaceholders(List<TestQuestions> openAnswers) {
        return openAnswers.stream()
                .map(a -> new QuestionResult(
                        a.getQuiz().getId(),
                        a.getQuiz().getQuestionText(),
                        a.getQuiz().getType(),
                        a.getUserResponse(),
                        null, false, PENDING_FEEDBACK, -1.0))
                .toList();
    }

    private double averageScore(List<QuestionResult> results) {
        if (results.isEmpty()) return 0.0;
        return results.stream()
                .filter(r -> r.score() >= 0)
                .mapToDouble(QuestionResult::score)
                .average()
                .orElse(0.0);
    }

    private List<QuestionResult> mergeResults(List<QuestionResult> mc, List<QuestionResult> open) {
        var merged = new ArrayList<>(mc);
        merged.addAll(open);
        return merged;
    }

    private String extractLetter(String response) {
        if (response == null || response.isBlank()) return "";
        String trimmed = response.trim();
        java.util.regex.Matcher m =
                java.util.regex.Pattern.compile("^([A-Da-d])[).\\s]").matcher(trimmed);
        return m.find() ? m.group(1).toUpperCase() : trimmed.toUpperCase();
    }
}