package com.edusupernova.edusupernova.exam.dto.response;

import com.edusupernova.edusupernova.test.dto.response.QuizDTO;
import java.util.List;

/**
 * A group of questions sharing a common context (extract, passage, theme).
 * Used in admin review and when pre-loading Paper 2 / Paper 3 structures.
 */
public record QuestionGroupDTO(
        Integer        id,
        String         title,
        String         contextText,
        String         contextImageUrl,
        Integer        orderIndex,
        List<QuizDTO>  questions
) {}
