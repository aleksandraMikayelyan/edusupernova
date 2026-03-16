package com.edusupernova.edusupernova.controller;


import com.edusupernova.edusupernova.service.EvaluationService;
import com.edusupernova.edusupernova.service.EvaluationService.TestEvaluationResult;
import com.edusupernova.edusupernova.service.EvaluationService.QuestionResult;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * Thin controller — only handles HTTP concerns (request/response mapping).
 * All business logic lives in EvaluationService.
 */
@Slf4j
@RestController
@RequestMapping("/api/feedback")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class FeedbackController {

    private final EvaluationService evaluationService;

    @PostMapping("/process")
    public ResponseEntity<FeedbackResponse> processFeedback(
            @RequestParam Integer testId,
            @RequestParam(defaultValue = "") String examType,
            @RequestParam(defaultValue = "") String sectionName) {

        log.info("Feedback requested for testId={}, examType={}, section={}", testId, examType, sectionName);

        TestEvaluationResult result = evaluationService.evaluateTest(testId, examType, sectionName);

        return ResponseEntity.ok(FeedbackResponse.from(result));
    }

    // ── Response DTOs ────────────────────────────────────────────────────────

    public record FeedbackResponse(
            String testMark,
            String mcScore,
            String openScore,
            List<QuestionFeedback> questionsFeedback) {

        public static FeedbackResponse from(TestEvaluationResult result) {
            return new FeedbackResponse(
                    formatScore(result.totalScore()),
                    formatScore(result.mcScore()),
                    formatScore(result.openScore()),
                    result.questionResults().stream()
                            .map(QuestionFeedback::from)
                            .toList());
        }

        private static String formatScore(double score) {
            return String.format("%.1f/10", score);
        }
    }

    public record QuestionFeedback(
            int    id,
            String text,
            String type,        // String in the DTO — frontend doesn't need the Java enum
            String aiCorrection) {

        public static QuestionFeedback from(QuestionResult q) {
            return new QuestionFeedback(
                    q.id(),
                    q.questionText(),
                    q.type().name(),   // ← .name() converts enum to String e.g. "MULTIPLE_CHOICE"
                    q.feedback());
        }
    }
}