package com.edusupernova.edusupernova.exam.dto.response;

import java.util.List;

/**
 * GET /exams/{examId}/courses
 * Shows the subject cards (e.g. Economics, Pure Maths, Listening...)
 */
public record CourseDTO(
        Integer id,
        String coursename,
        String description,
        String icon,
        Integer totalQuestions,
        Integer examId,
        String examName,
        List<PaperDTO> papers       // papers available for this course
) {}