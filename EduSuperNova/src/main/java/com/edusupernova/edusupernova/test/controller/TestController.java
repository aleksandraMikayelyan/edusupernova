package com.edusupernova.edusupernova.test.controller;

import com.edusupernova.edusupernova.test.dto.request.StartTestRequest;
import com.edusupernova.edusupernova.test.dto.request.SubmitAnswerRequest;
import com.edusupernova.edusupernova.test.dto.response.AnswerFeedbackDTO;
import com.edusupernova.edusupernova.test.dto.response.FeedBackDTO;
import com.edusupernova.edusupernova.test.dto.response.TestHistoryDTO;
import com.edusupernova.edusupernova.test.dto.response.TestQuestionDTO;
import com.edusupernova.edusupernova.test.dto.response.TestSessionDTO;
import com.edusupernova.edusupernova.model.TestQuestions;
import com.edusupernova.edusupernova.test.service.EvaluationService;
import com.edusupernova.edusupernova.test.service.ITestReportService;
import com.edusupernova.edusupernova.test.service.ITestSessionService;
import com.edusupernova.edusupernova.test.service.ITestSubmissionService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * REST controller for the test workflow.
 * Each dependency is a focused, single-responsibility service (ISP + DIP).
 */
@Slf4j
@RestController
@RequestMapping("/api/tests")
@RequiredArgsConstructor
public class TestController {

    private final ITestSessionService    sessionService;
    private final ITestSubmissionService submissionService;
    private final ITestReportService     reportService;
    private final EvaluationService      evaluationService;

    // ── Session ───────────────────────────────────────────────────────────────

    @PostMapping("/start")
    public ResponseEntity<TestSessionDTO> startTest(
            @RequestBody @Validated StartTestRequest request,
            Authentication auth) {
        return ResponseEntity.ok(sessionService.startTest(request, auth.getName()));
    }

    @GetMapping("/{testId}/session")
    public ResponseEntity<TestSessionDTO> getSession(
            @PathVariable Integer testId,
            Authentication auth) {
        return ResponseEntity.ok(sessionService.getSession(testId, auth.getName()));
    }

    // ── Submission ────────────────────────────────────────────────────────────

    @PostMapping("/{testId}/answer")
    public ResponseEntity<AnswerFeedbackDTO> submitAnswer(
            @PathVariable Integer testId,
            @RequestBody @Validated SubmitAnswerRequest request,
            Authentication auth) {
        return ResponseEntity.ok(submissionService.submitAnswer(testId, request, auth.getName()));
    }

    @PostMapping("/{testId}/submit")
    public ResponseEntity<FeedBackDTO> forceSubmit(
            @PathVariable Integer testId,
            Authentication auth) {
        return ResponseEntity.ok(reportService.forceSubmit(testId, auth.getName()));
    }

    // ── Reports ───────────────────────────────────────────────────────────────

    @GetMapping("/{testId}/report")
    public ResponseEntity<FeedBackDTO> getReport(
            @PathVariable Integer testId,
            Authentication auth) {
        return ResponseEntity.ok(reportService.getReport(testId, auth.getName()));
    }

    @GetMapping("/history")
    public ResponseEntity<List<TestHistoryDTO>> getHistory(Authentication auth) {
        return ResponseEntity.ok(reportService.getHistory(auth.getName()));
    }

    // ── Legacy endpoints ──────────────────────────────────────────────────────

    @PostMapping("/{testId}/evaluate")
    public ResponseEntity<EvaluationService.TestEvaluationResult> submitAndEvaluate(
            @PathVariable Integer testId,
            @RequestBody List<TestQuestions> answers,
            @RequestParam String examType,
            @RequestParam String sectionName) {

        boolean saved = submissionService.saveAnswers(testId, answers);
        if (!saved) {
            log.error("Could not persist answers for testId={}", testId);
            return ResponseEntity.internalServerError().build();
        }
        return ResponseEntity.ok(evaluationService.evaluateTest(testId, examType, sectionName));
    }

    @GetMapping("/{testId}/questions")
    public ResponseEntity<List<TestQuestionDTO>> getTestQuestions(@PathVariable Integer testId) {
        List<TestQuestions> questions = sessionService.getQuestionsByTestId(testId);
        if (questions.isEmpty()) return ResponseEntity.noContent().build();

        List<TestQuestionDTO> dtoList = questions.stream()
                .map(this::toDTO)
                .toList();
        return ResponseEntity.ok(dtoList);
    }

    // ── Private helpers ───────────────────────────────────────────────────────

    private TestQuestionDTO toDTO(TestQuestions q) {
        var quiz  = q.getQuiz();
        var group = quiz != null ? quiz.getQuestionGroup() : null;
        return new TestQuestionDTO(
                q.getId().getTestId(),
                q.getId().getQuizId(),
                null,
                quiz != null ? quiz.getQuestionText()        : null,
                quiz != null ? quiz.getQuestionType().name() : null,
                quiz != null && quiz.getDifficulty() != null ? quiz.getDifficulty().name() : "MEDIUM",
                quiz != null ? quiz.getOptionA() : null,
                quiz != null ? quiz.getOptionB() : null,
                quiz != null ? quiz.getOptionC() : null,
                quiz != null ? quiz.getOptionD() : null,
                quiz != null ? quiz.getOptionE() : null,
                q.getUserResponse(),
                q.getCorrectResponse(),
                q.getFeedbackIa(),
                group != null ? group.getId()              : null,
                group != null ? group.getTitle()           : null,
                group != null ? group.getContextText()     : null,
                group != null ? group.getContextImageUrl() : null,
                quiz  != null ? quiz.getGroupOrderIndex()  : null,
                quiz  != null ? quiz.getMarks()            : null
        );
    }
}
