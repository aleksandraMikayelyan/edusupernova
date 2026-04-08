package com.edusupernova.edusupernova.dto.response;

/**
 * POST /tests/{testId}/answer → returns this immediately
 *
 * Reveals the correct answer + Groq AI feedback after submission.
 * nextQuestion is null when the test is complete (last question answered).
 */
public record AnswerFeedbackDTO(
        Integer quizId,
        Boolean isCorrect,
        String correctAnswer,       // revealed only after submission
        String explanation,         // static explanation from DB
        String aiFeedback,          // Groq-generated personalised feedback
        Double aiScore,             // 0-10 for ESSAY/OPEN_ENDED, null for MCQ
        Boolean sessionComplete,    // true = navigate to report page
        TestQuestionDTO nextQuestion // null if sessionComplete = true
) {}