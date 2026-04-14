package com.edusupernova.edusupernova.dto.request;

import jakarta.validation.constraints.NotNull;

/**
 * POST /tests/start
 *
 * The student launches a test for a specific:
 *   - course   (e.g. Economics)
 *   - paper    (e.g. Paper 1 - MCQ)
 *   - unit     (optional — if null, draws from ALL units in the paper)
 *
 * Email is taken from the JWT token in the controller — NOT from the body.
 * This prevents students from starting tests on behalf of others.
 */
public record StartTestRequest(
        @NotNull
        Integer courseId,

        Integer paperId,            // nullable — if null, first paper for the course is used

        Integer unitId              // nullable — null means full paper, no unit filter
) {}
