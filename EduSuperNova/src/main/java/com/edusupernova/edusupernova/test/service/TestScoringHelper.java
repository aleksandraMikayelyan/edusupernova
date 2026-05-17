package com.edusupernova.edusupernova.test.service;

import com.edusupernova.edusupernova.model.Quiz;
import com.edusupernova.edusupernova.model.TestQuestionId;
import com.edusupernova.edusupernova.model.TestQuestions;
import com.edusupernova.edusupernova.model.Tests;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Stateless scoring and evaluation utilities shared across the test services.
 * Contains no repository dependencies — pure domain logic only.
 */
@Component
public class TestScoringHelper {

    private static final Pattern ANSWER_LETTER = Pattern.compile("^([A-Da-d])[).\\s]");

    // ── Question type classification ──────────────────────────────────────────

    public boolean isMCQType(Quiz.QuestionType type) {
        return switch (type) {
            case MULTIPLE_CHOICE, TRUE_FALSE_NG, NUMERIC_INPUT -> true;
            default -> false;
        };
    }

    // ── MCQ evaluation ────────────────────────────────────────────────────────

    public boolean evaluateMCQ(String userResponse, String correctAnswer) {
        String user    = extractLetter(userResponse);
        String correct = extractLetter(correctAnswer);
        return !user.isBlank() && user.equalsIgnoreCase(correct);
    }

    public String generateMCQFeedback(Quiz quiz, boolean isCorrect) {
        String prefix = isCorrect ? "Correct! " : "Incorrect. ";
        if (quiz.getExplanation() != null && !quiz.getExplanation().isBlank()) {
            return prefix + quiz.getExplanation();
        }
        return isCorrect
                ? "Correct!"
                : "Incorrect. The correct answer was: " + quiz.getCorrectAnswer();
    }

    /** Extracts leading answer letter — handles "D) full text..." and bare "D" formats. */
    public String extractLetter(String response) {
        if (response == null || response.isBlank()) return "";
        String trimmed = response.trim();
        Matcher m = ANSWER_LETTER.matcher(trimmed);
        return m.find() ? m.group(1).toUpperCase() : trimmed.toUpperCase();
    }

    // ── Score / grade ─────────────────────────────────────────────────────────

    public double calculatePercentage(int correct, int total) {
        return total > 0 ? Math.round((correct * 100.0) / total * 100.0) / 100.0 : 0.0;
    }

    public String calculateGrade(double percentage) {
        if (percentage >= 90) return "A*";
        if (percentage >= 80) return "A";
        if (percentage >= 70) return "B";
        if (percentage >= 60) return "C";
        if (percentage >= 50) return "D";
        return "U";
    }

    /**
     * Computes the final test score.
     * Open-ended tests: average AI score (0–10 → 0–100 %).
     * MCQ-only tests: classic correct/total percentage.
     */
    public double computeFinalScore(int correctCount, List<TestQuestions> allQuestions) {
        List<TestQuestions> scoredOpenEnded = allQuestions.stream()
                .filter(q -> q.getQuiz() != null && !isMCQType(q.getQuiz().getQuestionType()))
                .filter(q -> q.getAiScore() != null && q.getAiScore() >= 0)
                .toList();

        return scoredOpenEnded.isEmpty()
                ? calculatePercentage(correctCount, allQuestions.size())
                : Math.round(scoredOpenEnded.stream()
                        .mapToDouble(TestQuestions::getAiScore)
                        .average()
                        .orElse(0.0) * 10.0 * 100.0) / 100.0;
    }

    // ── Timer ─────────────────────────────────────────────────────────────────

    public long getRemainingSeconds(Tests test) {
        if (test.getStartedAt() == null || test.getTimeLimitMinutes() == null) return 0L;
        LocalDateTime expiresAt = test.getStartedAt().plusMinutes(test.getTimeLimitMinutes());
        long remaining = ChronoUnit.SECONDS.between(LocalDateTime.now(), expiresAt);
        return Math.max(0L, remaining);
    }

    // ── Builder ───────────────────────────────────────────────────────────────

    public TestQuestions buildTestQuestion(Tests test, Quiz quiz) {
        TestQuestionId id = new TestQuestionId(test.getId(), quiz.getId());
        TestQuestions tq = new TestQuestions();
        tq.setId(id);
        tq.setTest(test);
        tq.setQuiz(quiz);
        tq.setCorrectResponse(false);
        return tq;
    }
}
