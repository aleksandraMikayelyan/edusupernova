package com.edusupernova.edusupernova.service;

import com.edusupernova.edusupernova.data.ExamRepository;
import com.edusupernova.edusupernova.model.Exams;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * Manages exam data: listing, searching, creation, and updates.
 *
 * SRP  – each method has a single, named responsibility.
 * DIP  – depends on {@link ExamRepository} abstraction via constructor injection.
 */
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class ExamsService {

    private final ExamRepository examRepository;

    // ── Public API ────────────────────────────────────────────────────────────

    /** Returns all exams available on the dashboard. */
    public List<Exams> getDashboardExams() {
        return examRepository.findAll();
    }

    /**
     * Searches exams by name or description (case-insensitive).
     * Falls back to all exams when {@code searchTerm} is blank.
     */
    public List<Exams> search(String searchTerm) {
        if (searchTerm == null || searchTerm.isBlank()) {
            return getDashboardExams();
        }

        String term = searchTerm.trim();
        return examRepository
                .findByIsActiveTrueAndExamnameContainingIgnoreCaseOrIsActiveTrueAndDescriptionContainingIgnoreCaseOrderByExamnameAsc(
                        term, term);
    }

    /**
     * Returns an exam by ID.
     *
     * @throws IllegalArgumentException if no exam exists with the given ID
     */
    public Exams findById(Integer examId) {
        return examRepository.findById(examId)
                .orElseThrow(() -> new IllegalArgumentException("Exam not found: " + examId));
    }

    /**
     * Persists a new exam, setting it to active by default.
     *
     * @throws IllegalArgumentException if the exam is null or its name is
     *                                  blank or exceeds 100 characters
     */
    @Transactional
    public Exams createExam(Exams exam) {
        validateExam(exam);
        exam.setIsActive(true);
        return examRepository.save(exam);
    }

    /**
     * Activates or deactivates an exam.
     *
     * @throws IllegalArgumentException if the exam does not exist
     */
    @Transactional
    public void toggleActive(Integer examId, boolean active) {
        Exams exam = findById(examId);
        exam.setIsActive(active);
        examRepository.save(exam);
    }

    /**
     * Updates the mutable fields (name, description, icon) of an existing exam.
     * Active state is intentionally excluded — use {@link #toggleActive} instead.
     *
     * @throws IllegalArgumentException if the exam does not exist
     */
    @Transactional
    public Exams updateExam(Integer id, Exams updated) {
        Exams existing = findById(id);
        existing.setExamname(updated.getExamname());
        existing.setDescription(updated.getDescription());
        existing.setIcon(updated.getIcon());
        return examRepository.save(existing);
    }

    // ── Private helpers ───────────────────────────────────────────────────────

    private void validateExam(Exams exam) {
        if (exam == null) {
            throw new IllegalArgumentException("Exam cannot be null");
        }
        if (exam.getExamname() == null || exam.getExamname().isBlank()) {
            throw new IllegalArgumentException("Exam name cannot be empty");
        }
        if (exam.getExamname().length() > 100) {
            throw new IllegalArgumentException("Exam name cannot exceed 100 characters");
        }
    }
}