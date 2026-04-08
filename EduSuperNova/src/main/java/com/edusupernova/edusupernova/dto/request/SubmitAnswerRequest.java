package com.edusupernova.edusupernova.dto.request;

import jakarta.validation.constraints.NotNull;

/**
 * POST /tests/{testId}/answer
 *
 * userResponse is always a String to support all question types:
 *   MCQ          → "A", "B", "C", "D"
 *   TRUE_FALSE_NG → "TRUE", "FALSE", "NOT_GIVEN"
 *   NUMERIC_INPUT → "42" or "3.14"
 *   ESSAY / OPEN_ENDED → the student's full written response
 */
public record SubmitAnswerRequest(
        @NotNull
        Integer quizId,

        @NotNull
        String userResponse
) {}