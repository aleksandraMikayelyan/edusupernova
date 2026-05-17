package com.edusupernova.edusupernova.exam.service;

import com.edusupernova.edusupernova.data.ExamRepository;
import com.edusupernova.edusupernova.exam.dto.response.ExamDTO;
import com.edusupernova.edusupernova.model.Exams;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.edusupernova.edusupernova.exception.ResourceNotFoundException;
import java.util.List;

/**
 * Manages exam data: listing, searching, creation, updates, and time limits.
 *
 * CHANGED FROM ORIGINAL:
 *   - updateExam() now also updates timeLimitMinutes
 *   - getDashboardExams() returns List<ExamDTO> instead of List<Exams>
 *     (never expose entities from controllers)
 *   - Added toDTO() mapper
 */
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class ExamsService {

    private final ExamRepository examRepository;

    // ── Public API ────────────────────────────────────────────────────────────

    /** Returns all active exams for the dashboard. */
    public List<ExamDTO> getDashboardExams() {
        return examRepository.findByIsActiveTrue()
                .stream()
                .map(this::toDTO)
                .toList();
    }

    /**
     * Searches exams by name or description (case-insensitive).
     * Falls back to all active exams when searchTerm is blank.
     */
    public List<ExamDTO> search(String searchTerm) {
        if (searchTerm == null || searchTerm.isBlank()) {
            return getDashboardExams();
        }
        String term = searchTerm.trim();
        return examRepository
                .findByIsActiveTrueAndExamnameContainingIgnoreCaseOrIsActiveTrueAndDescriptionContainingIgnoreCaseOrderByExamnameAsc(
                        term, term)
                .stream()
                .map(this::toDTO)
                .toList();
    }

    /**
     * Returns an exam entity by ID (used internally by other services).
     *
     * @throws IllegalArgumentException if no exam exists with the given ID
     */
    public Exams findById(Integer examId) {
        return examRepository.findById(examId)
            .orElseThrow(() -> ResourceNotFoundException.of("Exam", examId));
    }

    /**
     * Creates a new exam (admin only).
     */
    @Transactional
    public ExamDTO createExam(Exams exam) {
        validateExam(exam);
        exam.setIsActive(true);
        if (exam.getTimeLimitMinutes() == null) {
            exam.setTimeLimitMinutes(120); // 2-hour default
        }
        return toDTO(examRepository.save(exam));
    }

    /**
     * Activates or deactivates an exam (admin only).
     */
    @Transactional
    public void toggleActive(Integer examId, boolean active) {
        Exams exam = findById(examId);
        exam.setIsActive(active);
        examRepository.save(exam);
    }

    /**
     * Updates mutable fields of an existing exam (admin only).
     *
     * CHANGED: now also updates timeLimitMinutes — admins set real
     * times per exam (IELTS Listening = 40 min, A Levels = 120 min, etc.)
     */
    @Transactional
    public ExamDTO updateExam(Integer id, Exams updated) {
        Exams existing = findById(id);
        existing.setExamname(updated.getExamname());
        existing.setDescription(updated.getDescription());
        existing.setIcon(updated.getIcon());
        if (updated.getTimeLimitMinutes() != null) {
            existing.setTimeLimitMinutes(updated.getTimeLimitMinutes());
        }
        return toDTO(examRepository.save(existing));
    }

    // ── Mapper ────────────────────────────────────────────────────────────────

    public ExamDTO toDTO(Exams exam) {
        return new ExamDTO(
                exam.getId(),
                exam.getExamname(),
                exam.getDescription(),
                exam.getIcon(),
                exam.getIsActive(),
                exam.getTimeLimitMinutes()
        );
    }

    // ── Private helpers ───────────────────────────────────────────────────────

    private void validateExam(Exams exam) {
        if (exam == null) throw new IllegalArgumentException("Exam cannot be null");
        if (exam.getExamname() == null || exam.getExamname().isBlank())
            throw new IllegalArgumentException("Exam name cannot be empty");
        if (exam.getExamname().length() > 100)
            throw new IllegalArgumentException("Exam name cannot exceed 100 characters");
    }
}