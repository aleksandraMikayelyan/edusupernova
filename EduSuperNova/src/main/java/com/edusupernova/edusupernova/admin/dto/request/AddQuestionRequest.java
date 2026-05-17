package com.edusupernova.edusupernova.admin.dto.request;

/**
 * Body for POST /api/admin/questions.
 * groupId and groupOrderIndex are optional — set only for grouped questions
 * (passages, data-response extracts, etc.).
 */
public record AddQuestionRequest(
        Integer courseId,
        Integer paperId,
        Integer groupId,           // null for standalone MCQ
        Integer groupOrderIndex,   // position within group: 1=(a), 2=(b), …
        String  questionType,
        String  questionText,
        String  optionA,
        String  optionB,
        String  optionC,
        String  optionD,
        String  correctAnswer,
        String  explanation,
        String  difficulty,
        Integer marks
) {}
