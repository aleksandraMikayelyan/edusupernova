package com.edusupernova.edusupernova.controller;

import com.edusupernova.edusupernova.model.Courses;
import com.edusupernova.edusupernova.model.Exams;
import com.edusupernova.edusupernova.service.CourseService;
import com.edusupernova.edusupernova.service.EnrollmentService;
import com.edusupernova.edusupernova.service.ExamsService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/exams")
@RequiredArgsConstructor
@CrossOrigin(
       origins = "http://localhost:8082",
        allowedHeaders = "*",
        allowCredentials = "true"
)
public class ExamController {

    private final ExamsService examsService;
    private final EnrollmentService enrollmentService;
    private final CourseService courseService;

    // --- DASHBOARD ---
    @GetMapping("/dashboard")
    public ResponseEntity<List<Exams>> getActiveExams() {
        return ResponseEntity.ok(examsService.getDashboardExams());
    }

    @GetMapping("/myexams/{userId}")
    public ResponseEntity<List<Exams>> getMyExams(@PathVariable int userId) {
        return ResponseEntity.ok(enrollmentService.getEnrolledExams(userId));
    }

    @GetMapping("/{examId}")
    public ResponseEntity<List<Courses>> getCoursesByExam(@PathVariable Integer examId) {
        return ResponseEntity.ok(courseService.getCoursesByExamId(examId));
    }

    // --- INSCRIPCIÓN ---
    @PostMapping("/{examId}/enroll")
    public ResponseEntity<String> enrollUser(@PathVariable int examId, @RequestParam int userId) {
        boolean success = enrollmentService.enroll(userId, examId);
        return success
                ? ResponseEntity.ok("Inscripción exitosa")
                : ResponseEntity.badRequest().body("El usuario ya está inscrito");
    }

    @DeleteMapping("/{examId}/unenroll")
    public ResponseEntity<Void> unenrollUser(@PathVariable int examId, @RequestParam int userId) {
        return enrollmentService.unenroll(userId, examId)
                ? ResponseEntity.noContent().build()
                : ResponseEntity.notFound().build();
    }

    @GetMapping("/{examId}/status")
    public ResponseEntity<Boolean> checkEnrollment(@PathVariable int examId, @RequestParam int userId) {
        return ResponseEntity.ok(enrollmentService.isEnrolled(userId, examId));
    }

    // --- ADMIN ---
    @PostMapping
    public ResponseEntity<Exams> create(@RequestBody Exams exam) {
        return ResponseEntity.ok(examsService.createExam(exam));
    }

    @PatchMapping("/{id}/toggle")
    public ResponseEntity<Void> toggle(@PathVariable Integer id, @RequestParam boolean active) {
        examsService.toggleActive(id, active);
        return ResponseEntity.noContent().build();
    }
}