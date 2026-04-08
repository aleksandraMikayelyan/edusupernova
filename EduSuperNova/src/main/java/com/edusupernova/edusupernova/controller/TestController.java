package com.edusupernova.edusupernova.controller;

import com.edusupernova.edusupernova.dto.response.TestQuestionDTO;
import com.edusupernova.edusupernova.model.TestQuestions;
import com.edusupernova.edusupernova.service.EvaluationService;
import com.edusupernova.edusupernova.service.TestService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * REST controller for the test workflow.
 *
 * NOTE: This controller is scheduled for a full rewrite in the next phase
 * (JWT-based email extraction, per-question submitAnswer flow).
 * It is currently kept minimal to allow compilation.
 *
 * Endpoints:
 *   POST /api/tests/{id}/evaluate    → submit answers + receive AI score
 *   GET  /api/tests/{id}/questions   → retrieve questions for a test
 */
@Slf4j
@RestController
@RequestMapping("/api/tests")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class TestController {

    private final TestService       testService;
    private final EvaluationService evaluationService;

    /**
     * Step 2 – User submits all answers at once.
     * Saves responses and triggers AI evaluation.
     */
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

    /**
     * Retrieves all questions for a test, mapped to DTOs.
     */
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

    // ── Private helpers ──────────────────────────────────────────────────────

    private TestQuestionDTO toDTO(TestQuestions q) {
        var quiz = q.getQuiz();
        return new TestQuestionDTO(
                q.getId().getTestId(),
                q.getId().getQuizId(),
                null,                                                    // questionNumber not available here
                quiz != null ? quiz.getQuestionText()          : null,
                quiz != null ? quiz.getQuestionType().name()   : null,
                quiz != null && quiz.getDifficulty() != null
                        ? quiz.getDifficulty().name() : "MEDIUM",
                quiz != null ? quiz.getOptionA() : null,
                quiz != null ? quiz.getOptionB() : null,
                quiz != null ? quiz.getOptionC() : null,
                quiz != null ? quiz.getOptionD() : null,
                quiz != null ? quiz.getOptionE() : null,
                q.getUserResponse(),
                q.getCorrectResponse(),
                q.getFeedbackIa()
        );
    }
}
