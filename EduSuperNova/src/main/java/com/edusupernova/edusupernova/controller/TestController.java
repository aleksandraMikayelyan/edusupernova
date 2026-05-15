package com.edusupernova.edusupernova.controller;

import com.edusupernova.edusupernova.dto.request.StartTestRequest;
import com.edusupernova.edusupernova.dto.request.SubmitAnswerRequest;
import com.edusupernova.edusupernova.dto.response.AnswerFeedbackDTO;
import com.edusupernova.edusupernova.dto.response.FeedBackDTO;
import com.edusupernova.edusupernova.dto.response.TestHistoryDTO;
import com.edusupernova.edusupernova.dto.response.TestQuestionDTO;
import com.edusupernova.edusupernova.dto.response.TestSessionDTO;
import com.edusupernova.edusupernova.model.TestQuestions;
import com.edusupernova.edusupernova.service.EvaluationService;
import com.edusupernova.edusupernova.service.TestService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * REST controller for the test workflow.
 *
 * New endpoints (JWT-authenticated):
 *   POST /api/tests/start                → start a test session
 *   POST /api/tests/{testId}/answer      → submit one answer, get instant feedback
 *   GET  /api/tests/{testId}/report      → final report after completion
 *
 * Legacy endpoints (kept for compatibility):
 *   POST /api/tests/{testId}/evaluate    → batch submit + AI score
 *   GET  /api/tests/{testId}/questions   → list all questions for a test
 */
@Slf4j
@RestController
@RequestMapping("/api/tests")
@RequiredArgsConstructor
public class TestController {

    private final TestService       testService;
    private final EvaluationService evaluationService;

    // ── New endpoints ─────────────────────────────────────────────────────────

    /**
     * Starts a new test session for the authenticated student.
     * Body: { courseId, paperId, unitId (optional) }
     * Returns: session metadata + first question.
     */
    @PostMapping("/start")
    public ResponseEntity<TestSessionDTO> startTest(
            @RequestBody @Validated StartTestRequest request,
            Authentication auth) {

        TestSessionDTO session = testService.startTest(request, auth.getName());
        return ResponseEntity.ok(session);
    }

    /**
     * Submits a single answer and returns immediate feedback + next question.
     * Body: { quizId, userResponse }
     */
    @PostMapping("/{testId}/answer")
    public ResponseEntity<AnswerFeedbackDTO> submitAnswer(
            @PathVariable Integer testId,
            @RequestBody @Validated SubmitAnswerRequest request,
            Authentication auth) {

        AnswerFeedbackDTO feedback = testService.submitAnswer(testId, request, auth.getName());
        return ResponseEntity.ok(feedback);
    }

    /**
     * Returns the full post-test report for the feedback/report page.
     */
    @GetMapping("/{testId}/report")
    public ResponseEntity<FeedBackDTO> getReport(
            @PathVariable Integer testId,
            Authentication auth) {

        FeedBackDTO report = testService.getReport(testId, auth.getName());
        return ResponseEntity.ok(report);
    }

    /**
     * Force-completes a test. Unanswered questions are scored 0.
     * Ensures every submit attempt appears in the user's history.
     */
    @PostMapping("/{testId}/submit")
    public ResponseEntity<FeedBackDTO> forceSubmit(
            @PathVariable Integer testId,
            Authentication auth) {

        FeedBackDTO report = testService.forceSubmit(testId, auth.getName());
        return ResponseEntity.ok(report);
    }

    /**
     * Returns the authenticated user's completed test history, newest first.
     */
    @GetMapping("/history")
    public ResponseEntity<List<TestHistoryDTO>> getHistory(Authentication auth) {
        return ResponseEntity.ok(testService.getHistory(auth.getName()));
    }

    // ── Legacy endpoints ──────────────────────────────────────────────────────

    @PostMapping("/{testId}/evaluate")
    public ResponseEntity<EvaluationService.TestEvaluationResult> submitAndEvaluate(
            @PathVariable Integer testId,
            @RequestBody List<TestQuestions> answers,
            @RequestParam String examType,
            @RequestParam String sectionName) {

        boolean saved = testService.saveAnswers(testId, answers);
        if (!saved) {
            log.error("Could not persist answers for testId={}", testId);
            return ResponseEntity.internalServerError().build();
        }

        EvaluationService.TestEvaluationResult result =
                evaluationService.evaluateTest(testId, examType, sectionName);
        return ResponseEntity.ok(result);
    }

    @GetMapping("/{testId}/questions")
    public ResponseEntity<List<TestQuestionDTO>> getTestQuestions(@PathVariable Integer testId) {
        List<TestQuestions> questions = testService.getQuestionsByTestId(testId);

        if (questions.isEmpty()) {
            return ResponseEntity.noContent().build();
        }

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
                quiz != null && quiz.getDifficulty() != null
                        ? quiz.getDifficulty().name() : "MEDIUM",
                quiz != null ? quiz.getOptionA() : null,
                quiz != null ? quiz.getOptionB() : null,
                quiz != null ? quiz.getOptionC() : null,
                quiz != null ? quiz.getOptionD() : null,
                quiz != null ? quiz.getOptionE() : null,
                q.getUserResponse(),
                q.getCorrectResponse(),
                q.getFeedbackIa(),
                // group context fields
                group != null ? group.getId()              : null,
                group != null ? group.getTitle()           : null,
                group != null ? group.getContextText()     : null,
                group != null ? group.getContextImageUrl() : null,
                quiz  != null ? quiz.getGroupOrderIndex()  : null,
                quiz  != null ? quiz.getMarks()            : null
        );
    }
}
