package com.edusupernova.edusupernova.exam.dto.response;

/**
 * GET /courses/{courseId}/units
 * Shown in the left sidebar of the Subject page.
 */
public record UnitDTO(
        Integer id,
        String title,
        String summaryPath,         // path to the .txt / .md summary file
        Integer queue,              // display order
        Integer courseId,
        String courseName
) {}