package com.edusupernova.edusupernova.service;

import com.edusupernova.edusupernova.data.TestQuestionsRepository;
import com.edusupernova.edusupernova.model.Quiz;
import com.edusupernova.edusupernova.model.TestQuestions;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.stream.IntStream;

/**
 * Orchestrates the full test evaluation:
 *   1. Loads answers from DB
 *   2. Scores multiple-choice by comparing against stored correct answers
 *   3. Scores open-ended answers via AI (Groq)
 *   4. Combines both into a weighted final score
 */
@Slf4j
@Service
@RequiredArgsConstructor
@Transactional
public class EvaluationService {

    private static final double MC_WEIGHT   = 0.70;
    private static final double OPEN_WEIGHT = 0.30;

    // Open-ended question types that require AI evaluation
    private static final Set<Quiz.QuestionType> OPEN_ENDED_TYPES = Set.of(
            Quiz.QuestionType.OPEN_ENDED,
            Quiz.QuestionType.LOGICAL_PROBLEMS
    );

    private final TestQuestionsRepository testQuestionRepo;
    private final OpenEndedEvaluator      openEndedEvaluator;

    public record TestEvaluationResult(
            double              totalScore,
            double              mcScore,
            double              openScore,
            List<QuestionResult> questionResults) {}

    public record QuestionResult(
            int                  id,
            String               questionText,
            Quiz.QuestionType    type,      // ← strongly typed enum, not String
            String               feedback,
            double               score) {}

    // ── Public API ───────────────────────────────────────────────────────────

    public TestEvaluationResult evaluateTest(Integer testId, String examType, String sectionName) {
        List<TestQuestions> allAnswers  = loadAnswers(testId);

        List<TestQuestions> mcAnswers   = filterByType(allAnswers, Quiz.QuestionType.MULTIPLE_CHOICE);
        List<TestQuestions> openAnswers = filterByTypes(allAnswers, OPEN_ENDED_TYPES);

        List<QuestionResult> mcResults   = evaluateMultipleChoice(mcAnswers);
        List<QuestionResult> openResults = evaluateOpenEnded(openAnswers, examType, sectionName);

        double mcScore   = averageScore(mcResults);
        double openScore = averageScore(openResults);
        double total     = weightedScore(mcScore, openScore);

        persistOpenEndedFeedback(openAnswers, openResults);

        log.info("Test {} evaluated — MC: {}, Open: {}, Total: {}", testId,
                String.format("%.1f", mcScore),
                String.format("%.1f", openScore),
                String.format("%.1f", total));

        return new TestEvaluationResult(total, mcScore, openScore, mergeResults(mcResults, openResults));
    }

    // ── Multiple Choice ──────────────────────────────────────────────────────

    private List<QuestionResult> evaluateMultipleChoice(List<TestQuestions> answers) {
        return answers.stream().map(this::scoreMultipleChoice).toList();
    }

    private QuestionResult scoreMultipleChoice(TestQuestions answer) {
        boolean isCorrect = isCorrectMultipleChoiceAnswer(answer);
        double  score     = isCorrect ? 10.0 : 0.0;
        String  feedback  = isCorrect
                ? "Correct answer."
                : "Incorrect. The correct answer was: " + correctAnswerOf(answer);

        answer.setCorrectResponse(isCorrect);

        return new QuestionResult(
                answer.getQuiz().getId(),
                answer.getQuiz().getQuestionText(),
                Quiz.QuestionType.MULTIPLE_CHOICE,
                feedback,
                score);
    }

    private boolean isCorrectMultipleChoiceAnswer(TestQuestions answer) {
        String userResponse  = answer.getUserResponse();
        String correctAnswer = answer.getQuiz().getCorrectAnswer();
        if (userResponse == null || correctAnswer == null) return false;
        return userResponse.trim().equalsIgnoreCase(correctAnswer.trim());
    }

    private String correctAnswerOf(TestQuestions answer) {
        String correct = answer.getQuiz().getCorrectAnswer();
        return correct != null ? correct : "N/A";
    }

    // ── Open-Ended ───────────────────────────────────────────────────────────

    private List<QuestionResult> evaluateOpenEnded(
            List<TestQuestions> answers, String examType, String sectionName) {

        if (answers.isEmpty()) return List.of();

        String context = buildContext(examType, sectionName);
        List<OpenEndedEvaluator.EvaluationResult> aiResults =
                openEndedEvaluator.evaluateBatch(answers, context);

        return mapToQuestionResults(answers, aiResults);
    }

    private List<QuestionResult> mapToQuestionResults(
            List<TestQuestions> answers,
            List<OpenEndedEvaluator.EvaluationResult> aiResults) {

        return IntStream.range(0, answers.size())
                .mapToObj(i -> {
                    TestQuestions q  = answers.get(i);
                    var           ai = aiResults.get(i);
                    return new QuestionResult(
                            q.getQuiz().getId(),
                            q.getQuiz().getQuestionText(),
                            q.getQuiz().getType(),   // Quiz.QuestionType enum — no cast needed
                            ai.feedback(),
                            ai.score());
                })
                .toList();
    }

    /**
     * Persists AI feedback back to the DB.
     * Side effect isolated here — OpenEndedEvaluator stays pure.
     */
    private void persistOpenEndedFeedback(
            List<TestQuestions> answers,
            List<QuestionResult> results) {

        IntStream.range(0, answers.size()).forEach(i -> {
            TestQuestions  q      = answers.get(i);
            QuestionResult result = results.get(i);
            q.setPunctuation((int) Math.round(result.score()));
            q.setFeedbackIa(result.feedback());
            q.setCorrectResponse(result.score() >= 6.0);
        });
    }

    // ── Helpers ──────────────────────────────────────────────────────────────

    private List<TestQuestions> loadAnswers(Integer testId) {
        List<TestQuestions> answers = testQuestionRepo.findByIdTestId(testId);
        if (answers.isEmpty()) {
            throw new IllegalStateException("No answers found for testId: " + testId);
        }
        return answers;
    }

    /** Filters by a single type — used for MULTIPLE_CHOICE */
    private List<TestQuestions> filterByType(List<TestQuestions> answers, Quiz.QuestionType type) {
        return answers.stream()
                .filter(a -> a.getQuiz() != null && type == a.getQuiz().getType())
                .toList();
    }

    /** Filters by a set of types — used for open-ended variants */
    private List<TestQuestions> filterByTypes(List<TestQuestions> answers, Set<Quiz.QuestionType> types) {
        return answers.stream()
                .filter(a -> a.getQuiz() != null && types.contains(a.getQuiz().getType()))
                .toList();
    }

    private double averageScore(List<QuestionResult> results) {
        if (results.isEmpty()) return 0.0;
        return results.stream().mapToDouble(QuestionResult::score).average().orElse(0.0);
    }

    private double weightedScore(double mcScore, double openScore) {
        return (mcScore * MC_WEIGHT) + (openScore * OPEN_WEIGHT);
    }

    private String buildContext(String examType, String sectionName) {
        return String.format("Exam: %s, Section: %s", examType, sectionName);
    }

    private List<QuestionResult> mergeResults(
            List<QuestionResult> mcResults,
            List<QuestionResult> openResults) {

        var merged = new ArrayList<>(mcResults);
        merged.addAll(openResults);
        return merged;
    }
}