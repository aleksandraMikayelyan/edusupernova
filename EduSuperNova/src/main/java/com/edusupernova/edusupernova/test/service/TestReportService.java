package com.edusupernova.edusupernova.test.service;

import com.edusupernova.edusupernova.data.TestQuestionsRepository;
import com.edusupernova.edusupernova.data.TestRepository;
import com.edusupernova.edusupernova.data.UserRepository;
import com.edusupernova.edusupernova.test.dto.response.FeedBackDTO;
import com.edusupernova.edusupernova.test.dto.response.TestHistoryDTO;
import com.edusupernova.edusupernova.exception.ForbiddenException;
import com.edusupernova.edusupernova.exception.ResourceNotFoundException;
import com.edusupernova.edusupernova.model.TestQuestions;
import com.edusupernova.edusupernova.model.Tests;
import com.edusupernova.edusupernova.model.Users;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * Generates post-test reports, test history, and force-completes abandoned sessions.
 */
@Slf4j
@Service
@RequiredArgsConstructor
@Transactional
public class TestReportService implements ITestReportService {

    private final TestRepository          testRepository;
    private final TestQuestionsRepository testQuestionsRepository;
    private final UserRepository          userRepository;
    private final TestMapper              testMapper;
    private final TestScoringHelper       scoringHelper;

    // ── Report ────────────────────────────────────────────────────────────────

    @Override
    @Transactional(readOnly = true)
    public FeedBackDTO getReport(Integer testId, String email) {
        Tests test = findTest(testId);
        assertOwnership(test, email);

        List<TestQuestions> allQuestions = testQuestionsRepository.findByIdTestId(testId);
        int total = allQuestions.size();

        long durationSeconds = test.getCompletedAt() != null
                ? ChronoUnit.SECONDS.between(test.getStartedAt(), test.getCompletedAt())
                : 0L;

        List<FeedBackDTO.QuestionFeedbackDTO> questionFeedback = allQuestions.stream()
                .map(tq -> testMapper.toQuestionFeedbackDTO(tq, testMapper.getQuestionNumber(allQuestions, tq)))
                .toList();

        double finalScore = scoringHelper.computeFinalScore(test.getTotalCorrect(), allQuestions);
        String grade      = scoringHelper.calculateGrade(finalScore);

        return new FeedBackDTO(
                test.getId(),
                test.getCourse().getCoursename(),
                test.getPaper() != null ? test.getPaper().getPaperName() : null,
                test.getUnit()  != null ? test.getUnit().getTitle()      : null,
                test.getTotalCorrect(),
                total,
                finalScore,
                grade,
                test.getStartedAt(),
                test.getCompletedAt(),
                durationSeconds,
                questionFeedback
        );
    }

    // ── Force submit ──────────────────────────────────────────────────────────

    @Override
    public FeedBackDTO forceSubmit(Integer testId, String email) {
        Tests test = findTest(testId);
        assertOwnership(test, email);

        if (test.getStatus() == Tests.TestStatus.COMPLETED) {
            return getReport(testId, email);
        }

        List<TestQuestions> allQuestions = testQuestionsRepository.findByIdTestId(testId);

        for (TestQuestions tq : allQuestions) {
            if (tq.getUserResponse() == null || tq.getUserResponse().isBlank()) {
                tq.setUserResponse("");
                tq.setCorrectResponse(false);
                tq.setFeedbackIa("Not answered.");
                if (!scoringHelper.isMCQType(tq.getQuiz().getQuestionType())) {
                    tq.setAiScore(0.0);
                }
                tq.setAnsweredAt(LocalDateTime.now());
                testQuestionsRepository.save(tq);
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
        testRepository.save(test);

        log.info("Force-submitted testId={} userId={} score={}", testId, test.getUser().getId(), test.getFinalScore());

        return getReport(testId, email);
    }

    // ── History ───────────────────────────────────────────────────────────────

    @Override
    @Transactional(readOnly = true)
    public List<TestHistoryDTO> getHistory(String email) {
        Users user = findUserByEmail(email);
        List<Tests> completed = testRepository.findByUserIdOrderByCreationDateDesc(user.getId())
                .stream()
                .filter(t -> t.getStatus() == Tests.TestStatus.COMPLETED)
                .toList();

        if (completed.isEmpty()) return List.of();

        List<Integer> testIds = completed.stream().map(Tests::getId).toList();
        List<Object[]> rows   = testQuestionsRepository.findQuizIdsByTestIds(testIds);

        Map<Integer, Set<Integer>> testToQuizIds = new HashMap<>();
        for (Object[] row : rows) {
            Integer testId = (Integer) row[0];
            Integer quizId = (Integer) row[1];
            testToQuizIds.computeIfAbsent(testId, k -> new HashSet<>()).add(quizId);
        }

        LinkedHashMap<String, Tests> seen = new LinkedHashMap<>();
        for (Tests t : completed) {
            Set<Integer> quizIds = testToQuizIds.getOrDefault(t.getId(), Set.of());
            String fingerprint = quizIds.stream()
                    .sorted().map(String::valueOf).collect(Collectors.joining(","));
            seen.putIfAbsent(fingerprint, t);
        }

        return seen.values().stream().map(testMapper::toHistoryDTO).toList();
    }

    // ── Private helpers ───────────────────────────────────────────────────────

    private Tests findTest(Integer testId) {
        return testRepository.findById(testId)
                .orElseThrow(() -> new ResourceNotFoundException("Test not found: " + testId));
    }

    private Users findUserByEmail(String email) {
        Users user = userRepository.findByEmail(email);
        if (user == null) throw new IllegalArgumentException("User not found: " + email);
        return user;
    }

    private void assertOwnership(Tests test, String email) {
        if (!test.getUser().getEmail().equals(email)) {
            throw new ForbiddenException("Test does not belong to user: " + email);
        }
    }
}
