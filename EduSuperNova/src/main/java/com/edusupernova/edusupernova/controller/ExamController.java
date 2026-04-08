package com.edusupernova.edusupernova.controller;

import com.edusupernova.edusupernova.dto.response.ExamDTO;
import com.edusupernova.edusupernova.model.Courses;
import com.edusupernova.edusupernova.model.Exams;
import com.edusupernova.edusupernova.service.CourseService;
import com.edusupernova.edusupernova.service.EnrollmentService;
import com.edusupernova.edusupernova.service.ExamsService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * REST controller for exam discovery, enrollment management, and admin operations.
 *
 * SRP – only handles HTTP concerns; all business logic lives in the services.
 */
@RestController
@RequestMapping("/api/exams")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class ExamController {

    private final ExamsService      examsService;
    private final EnrollmentService enrollmentService;
    private final CourseService     courseService;

    // ── Dashboard ─────────────────────────────────────────────────────────────

    @GetMapping("/dashboard")
    public ResponseEntity<List<ExamDTO>> getActiveExams() {
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

    // ── Enrollment ────────────────────────────────────────────────────────────

    @PostMapping("/{examId}/enroll")
    public ResponseEntity<String> enrollUser(
            @PathVariable int examId,
            @RequestParam int userId) {

        boolean enrolled = enrollmentService.enroll(userId, examId);
        return enrolled
                ? ResponseEntity.ok("Enrollment successful")
                : ResponseEntity.badRequest().body("User is already enrolled");
    }

    @DeleteMapping("/{examId}/unenroll")
    public ResponseEntity<Void> unenrollUser(
            @PathVariable int examId,
            @RequestParam int userId) {

        return enrollmentService.unenroll(userId, examId)
                ? ResponseEntity.noContent().build()
                : ResponseEntity.notFound().build();
    }

    @GetMapping("/{examId}/status")
    public ResponseEntity<Boolean> checkEnrollment(
            @PathVariable int examId,
            @RequestParam int userId) {

        return ResponseEntity.ok(enrollmentService.isEnrolled(userId, examId));
    }

    // ── Admin ─────────────────────────────────────────────────────────────────

    @PostMapping
    public ResponseEntity<ExamDTO> create(@RequestBody Exams exam) {
        return ResponseEntity.ok(examsService.createExam(exam));
    }

    @PatchMapping("/{id}/toggle")
    public ResponseEntity<Void> toggle(
            @PathVariable Integer id,
            @RequestParam boolean active) {

        examsService.toggleActive(id, active);
        return ResponseEntity.noContent().build();
    }
}