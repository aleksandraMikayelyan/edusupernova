package com.edusupernova.edusupernova.dto.response;

/**
 * GET /exams
 * Lightweight card shown on the exam selection screen.
 */
public record ExamDTO(
        Integer id,
        String examname,
        String description,
        String icon,
        Boolean isActive,
        Integer timeLimitMinutes    // default time for this exam
) {}