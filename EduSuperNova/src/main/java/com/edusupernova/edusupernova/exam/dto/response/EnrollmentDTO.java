package com.edusupernova.edusupernova.exam.dto.response;

import jakarta.validation.constraints.NotNull;
import java.time.LocalDateTime;

/**
 * POST /enrollments     → body uses EnrollmentRequest
 * GET  /enrollments/me  → returns List<EnrollmentDTO>
 */
public record EnrollmentDTO(
        Integer examId,
        String examName,
        String examIcon,
        LocalDateTime enrolledAt,
        Double progress             // 0.00 - 100.00
) {

    /**
     * POST /enrollments body
     */
    public record EnrollmentRequest(
            @NotNull
            Integer examId
    ) {}
}
