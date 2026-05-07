package com.edusupernova.edusupernova.controller;

import com.edusupernova.edusupernova.model.ALevelSection;
import com.edusupernova.edusupernova.model.Courses;
import com.edusupernova.edusupernova.service.CourseService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/courses")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class CourseController {

    private final CourseService courseService;

    /**
     * Returns courses for an exam, optionally filtered by A Level section.
     *
     * GET /api/courses?examTypeId=1          → all courses for exam 1
     * GET /api/courses?examTypeId=1&section=AS  → only AS courses
     * GET /api/courses?examTypeId=1&section=A2  → only A2 courses
     */
    @GetMapping
    public ResponseEntity<List<Courses>> getCourses(
            @RequestParam Integer examTypeId,
            @RequestParam(required = false) ALevelSection section) {

        List<Courses> courses = (section != null)
                ? courseService.getCoursesByExamIdAndSection(examTypeId, section)
                : courseService.getCoursesByExamId(examTypeId);

        return ResponseEntity.ok(courses);
    }
}
