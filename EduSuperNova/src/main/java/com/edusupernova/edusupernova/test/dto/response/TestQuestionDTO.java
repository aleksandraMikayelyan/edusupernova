package com.edusupernova.edusupernova.test.dto.response;

/**
 * A single question shown during an active test.
 * Options (A-E) are null when the question type is ESSAY / OPEN_ENDED.
 * optionE is only used for IELTS True/False/Not Given questions.
 *
 * The correct answer is NEVER sent to the frontend here —
 * it is only revealed in AnswerFeedbackDTO after the student submits.
 *
 * Group fields (groupId … marks) are non-null only for questions that belong
 * to a QuestionGroup (Paper 2 Data Response, Paper 3 Essay, IELTS passages…).
 * Standalone MCQ questions have all group fields as null.
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
        String feedbackIa,

        // Group context — null for standalone (MCQ) questions
        Integer groupId,
        String  groupTitle,         // e.g. "Extract A: The Global Coffee Market"
        String  contextText,        // the passage / transcript the student must read
        String  contextImageUrl,    // optional chart or table image URL
        Integer groupOrderIndex,    // position within the group: 1=(a), 2=(b)…
        Integer marks               // how many marks this sub-question is worth
) {}
