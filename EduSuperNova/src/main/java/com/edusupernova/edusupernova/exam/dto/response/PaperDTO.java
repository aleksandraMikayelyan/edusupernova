package com.edusupernova.edusupernova.exam.dto.response;

/**
 * Embedded inside CourseDTO and shown as buttons on the Subject page.
 * e.g. "Paper 1 - MCQ", "Paper 2 - Data Response", "Listening"
 */
public record PaperDTO(
        Integer id,
        String paperName,
        String instructions,
        String format,              // MCQ, ESSAY, LISTENING, READING, etc.
        Integer totalQuestions,
        Integer timeLimitMinutes,   // null = use exam-level time
        Integer orderIndex
) {}