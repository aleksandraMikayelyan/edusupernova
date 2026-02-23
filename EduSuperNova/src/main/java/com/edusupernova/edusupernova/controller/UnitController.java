package com.edusupernova.edusupernova.controller;

import com.edusupernova.edusupernova.model.Courses;
import com.edusupernova.edusupernova.model.Unit;
import com.edusupernova.edusupernova.service.CourseService;
import com.edusupernova.edusupernova.service.UnitService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/units")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class UnitController {

    private final CourseService courseService;
    private final UnitService unitService;

    /**
     * Endpoint for the Units Screen.
     * Returns the course info (Name, Icon) and the list of units.
     */
    @GetMapping("/course/{courseId}")
    public ResponseEntity<CourseUnitsResponse> getUnitsScreenData(@PathVariable Integer courseId) {
        // 1. Get Course Info
        Courses course = courseService.getCourseBasicInfo(courseId);

        // 2. Get Ordered Units
        List<Unit> units = unitService.getUnitsByCourseId(courseId);

        return ResponseEntity.ok(new CourseUnitsResponse(
                course.getCoursename(),
                course.getIcon(),
                units
        ));
    }

    // DTO to make the frontend's life easier
    public record CourseUnitsResponse(
            String courseName,
            String courseIcon,
            List<Unit> units
    ) {}
}