package com.edusupernova.edusupernova.controller;

import com.edusupernova.edusupernova.service.EvaluationService;
import com.edusupernova.edusupernova.service.EvaluationService.TestEvaluationResult;
import com.edusupernova.edusupernova.service.EvaluationService.QuestionResult;
import com.edusupernova.edusupernova.data.TestQuestionsRepository;
import com.edusupernova.edusupernova.model.TestQuestions;
import com.edusupernova.edusupernova.service.TestService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * Thin controller — only handles HTTP concerns (request/response mapping).
 * All business logic lives in EvaluationService.
 *
 * Endpoints:
 *   POST /api/feedback/process      – save answers + Phase-1 evaluation (called once by Test screen)
 *   GET  /api/feedback/{testId}     – polling endpoint for FeedbackPage (open-ended pending check)
 */
@Slf4j
@RestController
@RequestMapping("/api/feedback")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class FeedbackController {

    private final EvaluationService      evaluationService;
    private final TestService            testService;
    private final TestQuestionsRepository testQuestionsRepository;

    // ─────────────────────────────────────────────────────────────────────────
    // POST /api/feedback/process
    //
    // Called ONCE by the Test screen when the student submits all answers.
    //
    // What it does:
    //   1. Persists answers via testService.saveAnswers() so EvaluationService
    //      can read them from the DB (not stale in-memory state).
    //   2. Scores multiple-choice questions instantly via EvaluationService Phase 1.
    //   3. Fires async Groq AI evaluation for open-ended questions (Phase 2).
    //   4. Returns FeedbackResponse immediately — MC scores are ready; open-ended
    //      shows "Pending" and openEndedPending = true.
    //
    // The frontend must poll GET /api/feedback/{testId} until openEndedPending = false.
    // ─────────────────────────────────────────────────────────────────────────
    @PostMapping("/process")
    public ResponseEntity<FeedbackResponse> processFeedback(
            @RequestBody  List<TestQuestions> userAnswers,
            @RequestParam Integer             testId,
            @RequestParam(defaultValue = "")  String examType,
            @RequestParam(defaultValue = "")  String sectionName) {

        log.info("Feedback requested — testId={}, examType={}, section={}",
                testId, examType, sectionName);

        // Step 1: save answers (userResponse column in test_questions table)
        boolean saved = testService.saveAnswers(testId, userAnswers);
        if (!saved) {
            log.error("Failed to save answers for testId={}", testId);
            return ResponseEntity.internalServerError().build();
        }

        // Step 2+3: score MC (sync) + fire Groq for open-ended (async)
        TestEvaluationResult result =
                evaluationService.evaluateTest(testId, examType, sectionName);

        return ResponseEntity.ok(FeedbackResponse.from(result));
    }

    // ─────────────────────────────────────────────────────────────────────────
    // GET /api/feedback/{testId}
    //
    // Polling endpoint. FeedbackPage calls this every 4 seconds while
    // openEndedPending === true. Once Groq has written its results to the DB,
    // this returns openEndedPending = false and the real AI scores/feedback.
    //
    // This endpoint reads the current DB state without triggering any new
    // evaluation — it just re-assembles the FeedbackResponse from persisted rows.
    // ─────────────────────────────────────────────────────────────────────────
    @GetMapping("/{testId}")
    public ResponseEntity<FeedbackResponse> getFeedbackResult(
            @PathVariable Integer testId) {

        log.info("Polling feedback for testId={}", testId);

        List<TestQuestions> answers = testQuestionsRepository.findByIdTestId(testId);

        if (answers.isEmpty()) {
            return ResponseEntity.notFound().build();
        }

        // Re-assemble result from whatever is currently in the DB.
        // Rows where feedbackIa = "AI evaluation in progress..." or punctuation = -1
        // are treated as still pending.
        TestEvaluationResult result = evaluationService.buildResultFromPersistedRows(testId, answers);

        return ResponseEntity.ok(FeedbackResponse.from(result));
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Response DTOs
    // ─────────────────────────────────────────────────────────────────────────

    /**
     * Top-level response shape returned by both endpoints.
     *
     * openEndedPending — when true, FeedbackPage polls GET /{testId} every 4 s.
     * Scores formatted as "8.5/10"; "Pending" means AI has not finished yet.
     */
    public record FeedbackResponse(
            String              totalScore,
            String              mcScore,
            String              openScore,
            boolean             openEndedPending,
            List<QuestionFeedback> questionsFeedback) {

        public static FeedbackResponse from(TestEvaluationResult result) {
            return new FeedbackResponse(
                    formatScore(result.totalScore()),
                    formatScore(result.mcScore()),
                    formatScore(result.openScore()),
                    result.openEndedPending(),
                    result.questionResults().stream()
                            .map(QuestionFeedback::from)
                            .toList()
            );
        }

        private static String formatScore(double score) {
            return score < 0 ? "Pending" : String.format("%.1f/10", score);
        }
    }

    /**
     * Per-question feedback row.
     *
     * score         — "Pending" when AI hasn't scored yet (-1 sentinel from service).
     * isCorrect     — false for all pending questions; check score != "Pending" first.
     * correctAnswer — null for open-ended (no single correct answer).
     * userResponse  — what the student actually answered (shown in feedback page).
     */
    public record QuestionFeedback(
            int     questionId,
            String  questionText,
            String  type,
            String  userResponse,
            String  correctAnswer,
            boolean isCorrect,
            String  feedback,
            String  score) {

        public static QuestionFeedback from(QuestionResult q) {
            return new QuestionFeedback(
                    q.questionId(),
                    q.questionText(),
                    q.type().name(),
                    q.userResponse(),
                    q.correctAnswer(),
                    q.isCorrect(),
                    q.feedback(),
                    q.score() < 0 ? "Pending" : String.format("%.1f/10", q.score())
            );
        }
    }
}