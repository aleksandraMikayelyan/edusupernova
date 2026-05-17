package com.edusupernova.edusupernova.admin.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

/**
 * Admin-only request DTOs.
 * All endpoints under /admin/** require ROLE_ADMIN.
 */
public class AdminDTO {

    // ─────────────────────────────────────────
    // EXAM
    // ─────────────────────────────────────────

    /** POST /admin/exams  |  PUT /admin/exams/{id} */
    public record ExamRequest(
            @NotBlank String examname,
            String description,
            String icon,
            Boolean isActive,
            Integer timeLimitMinutes    // default time for this exam
    ) {}


    // ─────────────────────────────────────────
    // COURSE
    // ─────────────────────────────────────────

    /** POST /admin/courses  |  PUT /admin/courses/{id} */
    public record CourseRequest(
            @NotNull  Integer examId,
            @NotBlank String coursename,
            String description,
            String icon
    ) {}


    // ─────────────────────────────────────────
    // UNIT
    // ─────────────────────────────────────────

    /** POST /admin/units  |  PUT /admin/units/{id} */
    public record UnitRequest(
            @NotNull  Integer courseId,
            @NotBlank String title,
            @NotBlank String summaryPath,
            Integer queue               // display order, default 1
    ) {}


    // ─────────────────────────────────────────
    // PAPER
    // ─────────────────────────────────────────

    /** POST /admin/papers  |  PUT /admin/papers/{id} */
    public record PaperRequest(
            @NotNull  Integer courseId,
            @NotBlank String paperName,
            String instructions,
            @NotBlank String format,    // MCQ, ESSAY, LISTENING, READING, etc.
            @NotNull  Integer totalQuestions,
            Integer timeLimitMinutes,   // null = inherit from exam
            @NotNull  Integer orderIndex
    ) {}


    // ─────────────────────────────────────────
    // QUESTION (Quiz)
    // ─────────────────────────────────────────

    /**
     * POST /admin/questions
     * PUT  /admin/questions/{id}
     *
     * optionA-E are only required for MCQ / TRUE_FALSE_NG types.
     * For ESSAY / OPEN_ENDED, correctAnswer is the model answer used by the AI.
     * unitId is optional — links the question to a specific topic unit.
     */
    public record QuestionRequest(
            @NotNull  Integer courseId,
            @NotNull  Integer paperId,
            Integer unitId,             // optional unit tag

            @NotBlank String questionText,

            // MCQ / TRUE_FALSE_NG options
            String optionA,
            String optionB,
            String optionC,
            String optionD,
            String optionE,             // only for TRUE_FALSE_NG

            @NotBlank String correctAnswer,
            String explanation,         // static explanation shown in report
            String promptIa,            // custom Groq prompt for this question

            @NotBlank String type,      // MCQ, ESSAY, NUMERIC_INPUT, TRUE_FALSE_NG...
            String difficulty           // EASY, MEDIUM, HARD — default MEDIUM
    ) {}


    // ─────────────────────────────────────────
    // ADMIN STATS (response)
    // ─────────────────────────────────────────

    /** GET /admin/stats */
    public record AdminStatsDTO(
            Long totalUsers,
            Long totalStudents,
            Long totalAdmins,
            Long totalExams,
            Long totalCourses,
            Long totalQuestions,
            Long totalTestsToday,
            Long totalTestsAllTime
    ) {}
}