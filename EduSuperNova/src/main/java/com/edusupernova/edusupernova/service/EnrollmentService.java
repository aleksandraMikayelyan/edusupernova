package com.edusupernova.edusupernova.service;

import com.edusupernova.edusupernova.data.EnrollmentRepository;
import com.edusupernova.edusupernova.data.ExamRepository;
import com.edusupernova.edusupernova.data.UserRepository;
import com.edusupernova.edusupernova.model.Enrollment;
import com.edusupernova.edusupernova.model.EnrollmentId;
import com.edusupernova.edusupernova.model.Exams;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
@Transactional
public class EnrollmentService {

    @Autowired
    private EnrollmentRepository enrollmentRepo;

    @Autowired
    private UserRepository userRepo;

    @Autowired
    private ExamRepository examRepo;

    // Inscribir
    public boolean enroll(int userId, int examId) {
        if (enrollmentRepo.existsByUserIdAndExamId(userId, examId)) {
            return false; // Ya estaba inscrito
        }
        Enrollment enrollment = new Enrollment();
        EnrollmentId id = new EnrollmentId(userId, examId);
        enrollment.setId(id);
        enrollment.setUser(userRepo.findById(userId).orElseThrow());
        enrollment.setExam(examRepo.findById(examId).orElseThrow());
        enrollment.setEnrolledAt(LocalDateTime.now());
        enrollmentRepo.save(enrollment);
        return true;
    }

    // Desinscribir
    public boolean unenroll(int userId, int examId) {
        if (!enrollmentRepo.existsByUserIdAndExamId(userId, examId)) {
            return false;
        }
        enrollmentRepo.deleteByUserIdAndExamId(userId, examId);
        return true;
    }

    // Obtener exams inscritos
    public List<Exams> getEnrolledExams(int userId) {
        return enrollmentRepo.findEnrolledExamsByUserId(userId);
    }

    // Comprobar inscripción
    public boolean isEnrolled(int userId, int examId) {
        return enrollmentRepo.existsByUserIdAndExamId(userId, examId);
    }
}