package com.edusupernova.edusupernova.test.dto.response;

import java.time.LocalDateTime;

/**
 * One entry in the user's completed-test history.
 * Used by GET /api/tests/history.
 */
public record TestHistoryDTO(
        Integer testId,
        Integer courseId,
        String  courseName,
        Integer paperId,
        String  paperName,
        String  paperFormat,
        Double  finalScore,
        String  grade,
        Integer totalCorrect,
        Integer totalQuestions,
        LocalDateTime completedAt,
        Long    durationSeconds
) {}
