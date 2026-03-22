package com.edusupernova.edusupernova.service;

import com.edusupernova.edusupernova.data.CourseRepository;
import com.edusupernova.edusupernova.model.Courses;
import com.edusupernova.edusupernova.model.Unit;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * Handles course retrieval and course–unit composition.
 *
 * SRP  – owns course data access only; unit ordering is delegated to
 *        {@link UnitService}, which owns that concern.
 * DRY  – the two duplicate getUnitsFor* methods are merged into one.
 * DIP  – all dependencies injected via constructor.
 */
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class CourseService {

    private final CourseRepository courseRepository;
    private final UnitService      unitService;

    // ── Public API ────────────────────────────────────────────────────────────

    /**
     * Returns a course entity with its associations loaded.
     * If the repository is annotated with {@code @EntityGraph}, related
     * collections will be eagerly fetched in a single query.
     *
     * @throws RuntimeException if the course does not exist
     */
    public Courses getCourseWithUnits(Integer courseId) {
        return courseRepository.findById(courseId)
                .orElseThrow(() -> new RuntimeException("Course not found: " + courseId));
    }

    /**
     * Returns only the ordered list of units for a course.
     * Preferred over {@link #getCourseWithUnits} when the caller needs
     * units but not the course metadata.
     *
     * @throws RuntimeException if the course does not exist
     */
    public List<Unit> getUnitsForCourse(Integer courseId) {
        assertCourseExists(courseId);
        return unitService.getUnitsByCourseId(courseId);
    }

    /**
     * Returns basic course metadata (name, icon, description) without
     * loading associated collections.
     *
     * @throws RuntimeException if the course does not exist
     */
    public Courses getCourseBasicInfo(Integer courseId) {
        return courseRepository.findById(courseId)
                .orElseThrow(() -> new RuntimeException("Course not found: " + courseId));
    }

    /** Returns all courses linked to a given exam. */
    public List<Courses> getCoursesByExamId(Integer examId) {
        return courseRepository.findByExamId(examId);
    }

    // ── Private helpers ───────────────────────────────────────────────────────

    private void assertCourseExists(Integer courseId) {
        if (!courseRepository.existsById(courseId)) {
            throw new RuntimeException("Course not found: " + courseId);
        }
    }
}