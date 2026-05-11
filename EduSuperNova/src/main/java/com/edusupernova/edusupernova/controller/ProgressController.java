package com.edusupernova.edusupernova.controller;

import com.edusupernova.edusupernova.data.*;
import com.edusupernova.edusupernova.dto.response.CompletedGroupDTO;
import com.edusupernova.edusupernova.dto.response.CourseProgressDTO;
import com.edusupernova.edusupernova.dto.response.ExamProgressDTO;
import com.edusupernova.edusupernova.model.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * GET /api/progress/me
 *
 * Returns per-exam, per-course progress for the authenticated student.
 *
 * Pass% formula (per course):
 *   passPercentage = (completedLessons / totalLessons) × averageQuizScore
 *
 * Where:
 *   totalLessons     = number of Units in the course
 *   completedLessons = distinct unit-scoped tests completed
 *                      + full-paper tests (no unit) — capped at totalLessons
 *   averageQuizScore = mean finalScore (0–100) of all COMPLETED tests for the course
 */
@Slf4j
@RestController
@RequestMapping("/api/progress")
@RequiredArgsConstructor
public class ProgressController {

    private final UserRepository           userRepository;
    private final EnrollmentRepository    enrollmentRepository;
    private final CourseRepository        courseRepository;
    private final TestRepository          testRepository;
    private final UnitRepository          unitRepository;
    private final TestQuestionsRepository testQuestionsRepository;

    @GetMapping("/me")
    @Transactional(readOnly = true)
    public ResponseEntity<List<ExamProgressDTO>> getMyProgress(Authentication auth) {
        if (auth == null) return ResponseEntity.status(401).build();

        Users user = userRepository.findByEmail(auth.getName());
        if (user == null) return ResponseEntity.notFound().build();

        List<Exams> enrolledExams = enrollmentRepository.findEnrolledExamsByUserId(user.getId());

        List<ExamProgressDTO> result = enrolledExams.stream()
                .map(exam -> buildExamProgress(exam, user.getId()))
                .toList();

        log.debug("Progress requested for userId={}: {} exam(s)", user.getId(), result.size());
        return ResponseEntity.ok(result);
    }

    // ── Completed groups (for profile "Practice again" panel) ─────────────────

    /**
     * GET /api/progress/completed-groups
     *
     * Returns every QuestionGroup (extract / passage / essay theme) the student
     * has already finished at least once, across all papers.
     *
     * Each entry includes paperId + courseId so the frontend can build the
     * "Practice again" call:
     *   POST /api/tests/start  { courseId, paperId, forceGroupId }
     */
    @GetMapping("/completed-groups")
    @Transactional(readOnly = true)
    public ResponseEntity<List<CompletedGroupDTO>> getCompletedGroups(Authentication auth) {
        if (auth == null) return ResponseEntity.status(401).build();

        Users user = userRepository.findByEmail(auth.getName());
        if (user == null) return ResponseEntity.notFound().build();

        List<CompletedGroupDTO> result = testQuestionsRepository
                .findCompletedGroupsByUser(user.getId())
                .stream()
                .map(group -> {
                    Paper   paper  = group.getPaper();
                    Courses course = paper.getCourse();
                    String preview = group.getContextText() != null && group.getContextText().length() > 300
                            ? group.getContextText().substring(0, 300) + "…"
                            : group.getContextText();
                    return new CompletedGroupDTO(
                            group.getId(),
                            group.getTitle(),
                            preview,
                            paper.getId(),
                            paper.getPaperName(),
                            course.getId(),
                            course.getCoursename()
                    );
                })
                .toList();

        log.debug("Completed groups for userId={}: {}", user.getId(), result.size());
        return ResponseEntity.ok(result);
    }

    // ── Private helpers ───────────────────────────────────────────────────────

    private ExamProgressDTO buildExamProgress(Exams exam, int userId) {
        List<Courses> courses = courseRepository.findByExamId(exam.getId());

        List<CourseProgressDTO> courseProgress = courses.stream()
                .map(course -> buildCourseProgress(course, userId))
                .toList();

        return new ExamProgressDTO(
                exam.getId(),
                exam.getExamname(),
                exam.getIcon(),
                courseProgress
        );
    }

    private CourseProgressDTO buildCourseProgress(Courses course, int userId) {
        int totalLessons = unitRepository
                .findByCourseIdOrderByQueueAsc(course.getId()).size();

        List<Tests> completedTests = testRepository
                .findByUserIdAndCourseId(userId, course.getId())
                .stream()
                .filter(t -> t.getStatus() == Tests.TestStatus.COMPLETED)
                .toList();

        // Completed unit-scoped tests (each distinct unit = 1 lesson completed)
        long unitLessons = completedTests.stream()
                .filter(t -> t.getUnit() != null)
                .map(t -> t.getUnit().getId())
                .distinct()
                .count();

        // Full-paper completions (no unit filter) each count as 1 lesson
        long fullPaperLessons = completedTests.stream()
                .filter(t -> t.getUnit() == null)
                .count();

        int completedLessons = (int) Math.min(
                unitLessons + fullPaperLessons,
                totalLessons > 0 ? totalLessons : Long.MAX_VALUE
        );

        double avgScore = completedTests.isEmpty() ? 0.0 :
                completedTests.stream()
                        .mapToDouble(t -> t.getFinalScore() != null ? t.getFinalScore() : 0.0)
                        .average()
                        .orElse(0.0);

        double passPercentage = (totalLessons == 0 || completedTests.isEmpty()) ? 0.0 :
                (completedLessons / (double) totalLessons) * avgScore;

        return new CourseProgressDTO(
                course.getId(),
                course.getCoursename(),
                course.getIcon(),
                totalLessons,
                completedLessons,
                round1(avgScore),
                round1(passPercentage)
        );
    }

    private double round1(double v) {
        return Math.round(v * 10.0) / 10.0;
    }
}
