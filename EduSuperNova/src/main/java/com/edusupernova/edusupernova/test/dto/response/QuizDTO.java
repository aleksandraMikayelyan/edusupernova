package com.edusupernova.edusupernova.test.dto.response;

/**
 * Full question representation used for admin panels and post-test review.
 *
 * IMPORTANT: never return this from test-taking endpoints — it exposes correctAnswer.
 * During an active test use TestQuestionDTO instead.
 */
public record QuizDTO(
        Integer id,
        String  questionText,
        String  optionA,
        String  optionB,
        String  optionC,
        String  optionD,
        String  optionE,
        String  correctAnswer,   // exposed only in admin/review context
        String  questionType,
        String  difficulty,
        Integer marks,
        Integer groupOrderIndex
) {}
