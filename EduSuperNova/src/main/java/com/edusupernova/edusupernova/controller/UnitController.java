package com.edusupernova.edusupernova.controller;

import com.edusupernova.edusupernova.model.Courses;
import com.edusupernova.edusupernova.model.Unit;
import com.edusupernova.edusupernova.service.CourseService;
import com.edusupernova.edusupernova.service.UnitService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * REST controller for the Units screen.
 * Returns course metadata and its ordered unit list in a single response.
 *
 * SRP – only handles HTTP concerns; data composition is done in the services.
 */
@RestController
@RequestMapping("/api/units")
@RequiredArgsConstructor
@CrossOrigin(origins = "*", allowedHeaders = "*")
public class UnitController {

    private final CourseService courseService;
    private final UnitService   unitService;

    /**
     * Returns the course display name, icon, and its ordered unit list.
     * Used by the front-end Units screen to populate the header and content list.
     */
    @GetMapping("/course/{courseId}")
    public ResponseEntity<CourseUnitsResponse> getUnitsScreenData(@PathVariable Integer courseId) {
        Courses course = courseService.getCourseBasicInfo(courseId);
        List<Unit> units = unitService.getUnitsByCourseId(courseId);

        return ResponseEntity.ok(new CourseUnitsResponse(
                course.getCoursename(),
                course.getIcon(),
                units
        ));
    }

    // ── Response DTO ──────────────────────────────────────────────────────────

    /** Projection returned to the front-end for the Units screen. */
    public record CourseUnitsResponse(
            String courseName,
            String courseIcon,
            List<Unit> units
    ) {}
}