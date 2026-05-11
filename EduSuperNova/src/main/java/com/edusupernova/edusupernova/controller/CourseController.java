package com.edusupernova.edusupernova.controller;

import com.edusupernova.edusupernova.model.ALevelSection;
import com.edusupernova.edusupernova.model.Courses;
import com.edusupernova.edusupernova.service.CourseService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import java.util.List;

@RestController
@RequestMapping("/api/courses")
@RequiredArgsConstructor
public class CourseController {

    private final CourseService courseService;

    @Value("${app.file.upload-dir}")
    private String uploadDir;

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

    /**
     * Streams the formula sheet PDF for a course.
     * File is stored at {upload-dir}/formula-sheets/{courseId}.pdf
     */
    @GetMapping("/{courseId}/formula-sheet")
    public ResponseEntity<Resource> getFormulaSheet(@PathVariable Integer courseId) {
        try {
            Path file = Paths.get(uploadDir, "formula-sheets", courseId + ".pdf");
            if (!Files.exists(file)) return ResponseEntity.notFound().build();

            Resource resource = new UrlResource(file.toUri());
            return ResponseEntity.ok()
                    .contentType(MediaType.APPLICATION_PDF)
                    .header(HttpHeaders.CONTENT_DISPOSITION,
                            "inline; filename=\"formula-sheet-" + courseId + ".pdf\"")
                    .body(resource);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
}
