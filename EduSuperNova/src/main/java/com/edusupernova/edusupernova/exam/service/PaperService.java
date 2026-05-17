package com.edusupernova.edusupernova.exam.service;

import com.edusupernova.edusupernova.data.PaperRepository;
import com.edusupernova.edusupernova.data.CourseRepository;
import com.edusupernova.edusupernova.exam.dto.response.PaperDTO;
import com.edusupernova.edusupernova.model.Courses;
import com.edusupernova.edusupernova.model.Paper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.edusupernova.edusupernova.exception.ResourceNotFoundException;
import java.util.List;

/**
 * Manages Paper entities — the real exam sections (Paper 1 MCQ, Listening, Essay, etc.)
 * Owned by a Course; each Paper defines the format, time, and question pool
 * for a specific test mode within that course.
 */
@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class PaperService {

    private final PaperRepository  paperRepository;
    private final CourseRepository courseRepository;

    // ── Public API ────────────────────────────────────────────────────────────

    /**
     * Returns all papers for a course ordered by orderIndex.
     * These appear as buttons on the Subject page
     * (e.g. "Paper 1 - MCQ", "Paper 2 - Data Response", "Listening").
     */
    public List<PaperDTO> getPapersForCourse(Integer courseId) {
        return paperRepository.findByCourseIdOrderByOrderIndex(courseId)
                .stream()
                .map(this::toDTO)
                .toList();
    }

    /**
     * Returns a Paper entity by ID.
     *
     * @throws ResourceNotFoundException if not found
     */
    public Paper findById(Integer paperId) {
        return paperRepository.findById(paperId)
                .orElseThrow(() -> ResourceNotFoundException.of("Paper", paperId));
    }

    /**
     * Creates a new Paper for a course (admin only).
     */
    @Transactional
    public PaperDTO createPaper(Integer courseId, PaperDTO request) {
        Courses course = courseRepository.findById(courseId)
                .orElseThrow(() -> ResourceNotFoundException.of("Course", courseId));

        Paper paper = new Paper();
        paper.setCourse(course);
        paper.setPaperName(request.paperName());
        paper.setInstructions(request.instructions());
        paper.setFormat(Paper.PaperFormat.valueOf(request.format()));
        paper.setTotalQuestions(request.totalQuestions());
        paper.setTimeLimitMinutes(request.timeLimitMinutes());
        paper.setOrderIndex(request.orderIndex());

        Paper saved = paperRepository.save(paper);
        log.info("Created paper '{}' for courseId={}", saved.getPaperName(), courseId);
        return toDTO(saved);
    }

    /**
     * Updates a Paper's mutable fields (admin only).
     */
    @Transactional
    public PaperDTO updatePaper(Integer paperId, PaperDTO request) {
        Paper paper = findById(paperId);
        paper.setPaperName(request.paperName());
        paper.setInstructions(request.instructions());
        paper.setFormat(Paper.PaperFormat.valueOf(request.format()));
        paper.setTotalQuestions(request.totalQuestions());
        paper.setTimeLimitMinutes(request.timeLimitMinutes());
        paper.setOrderIndex(request.orderIndex());

        return toDTO(paperRepository.save(paper));
    }

    /**
     * Deletes a Paper (admin only).
     */
    @Transactional
    public void deletePaper(Integer paperId) {
        if (!paperRepository.existsById(paperId)) {
            throw ResourceNotFoundException.of("Paper", paperId);
        }
        paperRepository.deleteById(paperId);
        log.info("Deleted paperId={}", paperId);
    }

    // ── Mapper ────────────────────────────────────────────────────────────────

    public PaperDTO toDTO(Paper paper) {
        return new PaperDTO(
                paper.getId(),
                paper.getPaperName(),
                paper.getInstructions(),
                paper.getFormat().name(),
                paper.getTotalQuestions(),
                paper.getTimeLimitMinutes(),
                paper.getOrderIndex()
        );
    }
}
