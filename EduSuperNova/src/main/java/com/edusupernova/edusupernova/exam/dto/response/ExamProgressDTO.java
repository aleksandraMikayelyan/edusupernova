package com.edusupernova.edusupernova.exam.dto.response;

import java.util.List;

/**
 * Per-exam progress wrapper returned by GET /api/progress/me.
 * Contains one ExamProgressDTO per enrolled exam, each holding
 * CourseProgressDTO entries for every course in that exam.
 */
public record ExamProgressDTO(
        int                    examId,
        String                 examName,
        String                 examIcon,
        List<CourseProgressDTO> courses
) {}
