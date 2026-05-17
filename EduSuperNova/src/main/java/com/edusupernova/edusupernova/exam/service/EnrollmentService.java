package com.edusupernova.edusupernova.exam.service;

import com.edusupernova.edusupernova.data.EnrollmentRepository;
import com.edusupernova.edusupernova.data.ExamRepository;
import com.edusupernova.edusupernova.data.UserRepository;
import com.edusupernova.edusupernova.model.Enrollment;
import com.edusupernova.edusupernova.model.EnrollmentId;
import com.edusupernova.edusupernova.model.Exams;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.edusupernova.edusupernova.exception.ResourceNotFoundException;
import com.edusupernova.edusupernova.exception.BusinessRuleException;
import org.springframework.dao.DataIntegrityViolationException;
import java.time.LocalDateTime;
import java.util.List;

/**
 * Manages exam enrollment lifecycle: enroll, unenroll, status check,
 * and enrolled-exam listing for a given user.
 *
 * DIP – all dependencies injected via constructor.
 */
@Service
@RequiredArgsConstructor
@Transactional
public class EnrollmentService {

    private final EnrollmentRepository enrollmentRepository;
    private final UserRepository       userRepository;
    private final ExamRepository       examRepository;

    // ── Public API ────────────────────────────────────────────────────────────

    /**
     * Enrolls a user in an exam.
     *
     * @return {@code true} if enrollment was created, {@code false} if the
     *         user was already enrolled
     */
    public boolean enroll(int userId, int examId) {
        if (enrollmentRepository.existsByUserIdAndExamId(userId, examId)) {
            return false;
        }
        try {
            enrollmentRepository.save(buildEnrollment(userId, examId));
            return true;
        } catch (DataIntegrityViolationException ex) {
            // Concurrent request won the race — treat as "already enrolled"
            return false;
        }
    }

    /**
     * Removes a user's enrollment from an exam.
     *
     * @return {@code true} if the enrollment was deleted, {@code false} if
     *         no enrollment existed
     */
    public boolean unenroll(int userId, int examId) {
        if (!enrollmentRepository.existsByUserIdAndExamId(userId, examId)) {
            return false;
        }
        enrollmentRepository.deleteByUserIdAndExamId(userId, examId);
        return true;
    }

    /** Returns all exams the user is currently enrolled in. */
    @Transactional(readOnly = true)
    public List<Exams> getEnrolledExams(int userId) {
        return enrollmentRepository.findEnrolledExamsByUserId(userId);
    }

    /** Returns {@code true} if the user is enrolled in the given exam. */
    @Transactional(readOnly = true)
    public boolean isEnrolled(int userId, int examId) {
        return enrollmentRepository.existsByUserIdAndExamId(userId, examId);
    }

    // ── Private helpers ───────────────────────────────────────────────────────

    private Enrollment buildEnrollment(int userId, int examId) {
        Enrollment enrollment = new Enrollment();
        enrollment.setId(new EnrollmentId(userId, examId));
        enrollment.setUser(userRepository.findById(userId)
                .orElseThrow(() -> ResourceNotFoundException.of("User", userId)));
        enrollment.setExam(examRepository.findById(examId)
                .orElseThrow(() -> ResourceNotFoundException.of("Exam", examId)));
        enrollment.setEnrolledAt(LocalDateTime.now());
        return enrollment;
    }
}