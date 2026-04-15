package com.edusupernova.edusupernova.dto.response;

/**
 * Per-course progress snapshot for the student Profile dashboard.
 *
 * passPercentage formula:
 *   Pass% = (completedLessons / totalLessons) × averageQuizScore
 *
 * Where:
 *   completedLessons = distinct unit-filtered tests completed +
 *                      full-paper tests completed (capped at totalLessons)
 *   totalLessons     = total units for this course
 *   averageQuizScore = mean finalScore (0–100) of all completed tests
 */
public record CourseProgressDTO(
        int    courseId,
        String courseName,
        String courseIcon,
        int    totalLessons,
        int    completedLessons,
        double averageQuizScore,   // 0–100
        double passPercentage      // (completedLessons/totalLessons) × averageQuizScore
) {}
