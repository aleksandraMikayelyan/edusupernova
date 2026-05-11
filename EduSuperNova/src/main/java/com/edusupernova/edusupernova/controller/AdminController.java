package com.edusupernova.edusupernova.controller;

import com.edusupernova.edusupernova.data.CourseRepository;
import com.edusupernova.edusupernova.data.PaperRepository;
import com.edusupernova.edusupernova.data.QuestionGroupRepository;
import com.edusupernova.edusupernova.data.QuizRepository;
import com.edusupernova.edusupernova.dto.request.AddQuestionRequest;
import com.edusupernova.edusupernova.dto.response.ExamDTO;
import com.edusupernova.edusupernova.model.Courses;
import com.edusupernova.edusupernova.model.Paper;
import com.edusupernova.edusupernova.model.Quiz;
import com.edusupernova.edusupernova.model.QuestionGroup;
import com.edusupernova.edusupernova.service.ExamsService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;

import java.util.List;

/**
 * Admin-only REST endpoints.
 *   GET    /api/admin/exams                         → all exams
 *   GET    /api/admin/exams/{examId}/courses         → courses + papers
 *   GET    /api/admin/papers/{paperId}/groups        → question groups for a paper
 *   POST   /api/admin/groups                         → create a question group
 *   POST   /api/admin/questions                      → add a question
 *   DELETE /api/admin/questions/{id}                 → delete a question
 */
@Slf4j
@RestController
@RequestMapping("/api/admin")
@RequiredArgsConstructor
public class AdminController {

    private final ExamsService             examsService;
    private final CourseRepository         courseRepository;
    private final PaperRepository          paperRepository;
    private final QuizRepository           quizRepository;
    private final QuestionGroupRepository  questionGroupRepository;

    @Value("${app.file.upload-dir}")
    private String uploadDir;

    // ── Lightweight response types ─────────────────────────────────────────────

    public record AdminCourseDTO(Integer id, String coursename, List<AdminPaperDTO> papers) {}
    public record AdminPaperDTO (Integer id, String paperName,  String format) {}
    public record AdminGroupDTO (Integer id, String title,      Integer orderIndex) {}

    public record AddGroupRequest(
            Integer paperId,
            String  title,
            String  contextText,
            String  contextImageUrl,
            Integer orderIndex
    ) {}

    // ── Exam list ─────────────────────────────────────────────────────────────

    @GetMapping("/exams")
    public ResponseEntity<List<ExamDTO>> getExams() {
        return ResponseEntity.ok(examsService.getDashboardExams());
    }

    // ── Courses + papers ──────────────────────────────────────────────────────

    @GetMapping("/exams/{examId}/courses")
    public ResponseEntity<List<AdminCourseDTO>> getCoursesWithPapers(
            @PathVariable Integer examId) {

        List<AdminCourseDTO> result = courseRepository.findByExamId(examId)
                .stream()
                .map(c -> new AdminCourseDTO(
                        c.getId(),
                        c.getCoursename(),
                        paperRepository.findByCourseIdOrderByOrderIndex(c.getId())
                                .stream()
                                .map(p -> new AdminPaperDTO(
                                        p.getId(),
                                        p.getPaperName(),
                                        p.getFormat() != null ? p.getFormat().name() : null))
                                .toList()))
                .toList();

        return ResponseEntity.ok(result);
    }

    // ── Question groups ───────────────────────────────────────────────────────

    @GetMapping("/papers/{paperId}/groups")
    public ResponseEntity<List<AdminGroupDTO>> getGroupsForPaper(
            @PathVariable Integer paperId) {

        List<AdminGroupDTO> groups = questionGroupRepository
                .findByPaperIdOrderByOrderIndexAsc(paperId)
                .stream()
                .map(g -> new AdminGroupDTO(g.getId(), g.getTitle(), g.getOrderIndex()))
                .toList();

        return ResponseEntity.ok(groups);
    }

    @PostMapping("/groups")
    public ResponseEntity<AdminGroupDTO> createGroup(@RequestBody AddGroupRequest req) {
        Paper paper = paperRepository.findById(req.paperId())
                .orElseThrow(() -> new IllegalArgumentException("Paper not found: " + req.paperId()));

        QuestionGroup group = new QuestionGroup();
        group.setPaper(paper);
        group.setTitle(req.title());
        group.setContextText(req.contextText());
        group.setContextImageUrl(req.contextImageUrl());
        group.setOrderIndex(req.orderIndex() != null ? req.orderIndex() : 1);

        QuestionGroup saved = questionGroupRepository.save(group);
        return ResponseEntity.ok(new AdminGroupDTO(saved.getId(), saved.getTitle(), saved.getOrderIndex()));
    }

    // ── Add question ──────────────────────────────────────────────────────────

    @PostMapping("/questions")
    public ResponseEntity<Void> addQuestion(@RequestBody AddQuestionRequest req) {
        Courses course = courseRepository.findById(req.courseId())
                .orElseThrow(() -> new IllegalArgumentException("Course not found: " + req.courseId()));
        Paper paper = paperRepository.findById(req.paperId())
                .orElseThrow(() -> new IllegalArgumentException("Paper not found: " + req.paperId()));

        Quiz quiz = new Quiz();
        quiz.setCourse(course);
        quiz.setPaper(paper);
        quiz.setQuestionType(Quiz.QuestionType.valueOf(req.questionType()));
        quiz.setQuestionText(req.questionText());
        quiz.setOptionA(req.optionA());
        quiz.setOptionB(req.optionB());
        quiz.setOptionC(req.optionC());
        quiz.setOptionD(req.optionD());
        quiz.setCorrectAnswer(req.correctAnswer() != null ? req.correctAnswer() : "");
        quiz.setExplanation(req.explanation());
        quiz.setDifficulty(req.difficulty() != null
                ? Quiz.Difficulty.valueOf(req.difficulty())
                : Quiz.Difficulty.MEDIUM);
        quiz.setMarks(req.marks());

        // Attach to a question group if provided
        if (req.groupId() != null) {
            QuestionGroup group = questionGroupRepository.findById(req.groupId())
                    .orElseThrow(() -> new IllegalArgumentException("Group not found: " + req.groupId()));
            quiz.setQuestionGroup(group);
            quiz.setGroupOrderIndex(req.groupOrderIndex());
        }

        quizRepository.save(quiz);
        return ResponseEntity.ok().build();
    }

    // ── Delete question ───────────────────────────────────────────────────────

    @DeleteMapping("/questions/{id}")
    public ResponseEntity<Void> deleteQuestion(@PathVariable Integer id) {
        if (!quizRepository.existsById(id)) {
            return ResponseEntity.notFound().build();
        }
        quizRepository.deleteById(id);
        return ResponseEntity.noContent().build();
    }

    // ── Formula sheet upload ──────────────────────────────────────────────────

    /**
     * Uploads a formula sheet PDF for a course.
     * Stored at {upload-dir}/formula-sheets/{courseId}.pdf
     * Replaces any existing sheet for the same course.
     */
    @PostMapping(value = "/courses/{courseId}/formula-sheet", consumes = "multipart/form-data")
    public ResponseEntity<Void> uploadFormulaSheet(
            @PathVariable Integer courseId,
            @RequestParam("file") MultipartFile file) {

        if (!courseRepository.existsById(courseId)) {
            return ResponseEntity.notFound().build();
        }
        if (file.isEmpty()) {
            return ResponseEntity.badRequest().build();
        }
        try {
            Path dir = Paths.get(uploadDir, "formula-sheets");
            Files.createDirectories(dir);
            Path dest = dir.resolve(courseId + ".pdf");
            Files.copy(file.getInputStream(), dest, StandardCopyOption.REPLACE_EXISTING);
            log.info("Formula sheet uploaded for courseId={} → {}", courseId, dest);
            return ResponseEntity.ok().build();
        } catch (Exception e) {
            log.error("Formula sheet upload failed for courseId={}: {}", courseId, e.getMessage());
            return ResponseEntity.internalServerError().build();
        }
    }
}
