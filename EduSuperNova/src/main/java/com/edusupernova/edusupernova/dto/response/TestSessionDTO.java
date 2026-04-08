package com.edusupernova.edusupernova.dto.response;

import java.time.LocalDateTime;

/**
 * POST /tests/start → returns this
 * GET  /tests/{testId} → returns this
 *
 * Contains everything the frontend needs to render the test page:
 * session metadata + the first/current unanswered question.
 */
public record TestSessionDTO(
        Integer testId,
        String courseName,
        String paperName,
        String paperFormat,         // MCQ, ESSAY, LISTENING, etc.
        String unitName,            // null if full paper (no unit filter)
        Integer totalQuestions,
        Integer answeredCount,
        Integer totalCorrect,
        String status,              // IN_PROGRESS, COMPLETED, ABANDONED
        LocalDateTime startedAt,
        Integer timeLimitMinutes,   // from exam or paper
        Long remainingSeconds,      // calculated server-side
        TestQuestionDTO currentQuestion  // null if test is complete
) {}