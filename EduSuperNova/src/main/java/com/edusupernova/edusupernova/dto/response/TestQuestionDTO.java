package com.edusupernova.edusupernova.dto.response;

/**
 * A single question shown during an active test.
 * Options (A-E) are null when the question type is ESSAY / OPEN_ENDED.
 * optionE is only used for IELTS True/False/Not Given questions.
 *
 * The correct answer is NEVER sent to the frontend here —
 * it is only revealed in AnswerFeedbackDTO after the student submits.
 */
public record TestQuestionDTO(
        Integer testId,
        Integer quizId,
        Integer questionNumber,     // 1-based position in this session
        String questionText,
        String type,                // MCQ, ESSAY, NUMERIC_INPUT, TRUE_FALSE_NG, etc.
        String difficulty,          // EASY, MEDIUM, HARD

        // MCQ / TRUE_FALSE_NG options — null for open-ended types
        String optionA,
        String optionB,
        String optionC,
        String optionD,
        String optionE,             // only for TRUE_FALSE_NG ("Not Given")

        // Already-answered state (for revisiting a test session)
        String userResponse,
        Boolean correctResponse,
        String feedbackIa
) {}
