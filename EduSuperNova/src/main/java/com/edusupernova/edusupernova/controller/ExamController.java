package com.edusupernova.edusupernova.controller;

import com.edusupernova.edusupernova.model.Exams;
import com.edusupernova.edusupernova.service.EnrollmentService;
import com.edusupernova.edusupernova.service.ExamsService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/exams")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class ExamController {

    private final ExamsService examsService;
    private final EnrollmentService enrollmentService; // 1. Inyectar el servicio

    // --- MÉTODOS PARA EL DASHBOARD ---

    @GetMapping("/dashboard")
    public ResponseEntity<List<Exams>> getActiveExams() {
        return ResponseEntity.ok(examsService.getDashboardExams());
    }

    // 2. Nuevo: Obtener solo los exámenes donde el alumno ya está inscrito
    @GetMapping("/my-exams/{userId}")
    public ResponseEntity<List<Exams>> getMyExams(@PathVariable int userId) {
        return ResponseEntity.ok(enrollmentService.getEnrolledExams(userId));
    }

    // --- MÉTODOS DE INSCRIPCIÓN ---

    // 3. Inscribirse a un examen
    @PostMapping("/{examId}/enroll")
    public ResponseEntity<String> enrollUser(@PathVariable int examId, @RequestParam int userId) {
        boolean success = enrollmentService.enroll(userId, examId);
        if (success) {
            return ResponseEntity.ok("Inscripción exitosa");
        }
        return ResponseEntity.badRequest().body("El usuario ya está inscrito en este examen");
    }

    // 4. Desvincularse de un examen
    @DeleteMapping("/{examId}/unenroll")
    public ResponseEntity<Void> unenrollUser(@PathVariable int examId, @RequestParam int userId) {
        boolean success = enrollmentService.unenroll(userId, examId);
        if (success) {
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.notFound().build();
    }

    // 5. Comprobar estado (útil para que el botón en React Native diga "Inscrito" o "Inscribirse")
    @GetMapping("/{examId}/status")
    public ResponseEntity<Boolean> checkEnrollment(@PathVariable int examId, @RequestParam int userId) {
        return ResponseEntity.ok(enrollmentService.isEnrolled(userId, examId));
    }

    // --- MÉTODOS PARA ADMINS ---

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