package com.edusupernova.edusupernova.controller;

import com.edusupernova.edusupernova.dto.StartTestRequest;
import com.edusupernova.edusupernova.dto.TestQuestionDTO;
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
 * SRP  – only handles HTTP concerns (request parsing, response building).
 *        All business logic lives in {@link TestService} / {@link EvaluationService}.
 * DIP  – depends on service interfaces, not concrete implementations.
 *
 * Workflow:
 *   POST /api/tests/start            → Step 1: create a randomised test
 *   POST /api/tests/{id}/evaluate    → Step 2: submit answers and receive AI score
 *   GET  /api/tests/{id}/questions   → retrieve questions (and feedback) for a test
 */
@Slf4j
@RestController
@RequestMapping("/api/tests")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class TestController {

    private final TestService       testService;
    private final EvaluationService evaluationService;

    // ── Endpoints ────────────────────────────────────────────────────────────

    /**
     * Step 1 – "Check my knowledge" button.
     * Randomly selects 15 MC + 5 open-ended questions and persists the test.
     *
     * @return the new test ID, used by the front-end for all subsequent calls
     */
    @PostMapping("/start")
    public ResponseEntity<Integer> startTest(@RequestBody StartTestRequest request) {
        int testId = testService.createTestByEmail(request.getEmail(), request.getCourseId());
        log.info("Test started: testId={}, email={}, courseId={}",
                testId, request.getEmail(), request.getCourseId());
        return ResponseEntity.ok(testId);
    }

    /**
     * Step 2 – User submits answers.
     * Saves responses and triggers AI evaluation.
     *
     * @return full evaluation result, or 500 if answers could not be persisted
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
     * Retrieves all questions for a test, mapped to DTOs to avoid Hibernate
     * proxy serialisation issues.
     *
     * @return 200 with question list, or 204 if the test has no questions yet
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

    /** Maps a {@link TestQuestions} entity to a serialisation-safe DTO. */
    private TestQuestionDTO toDTO(TestQuestions q) {
        return TestQuestionDTO.builder()
                .testId(q.getId().getTestId())
                .quizId(q.getId().getQuizId())
                .questionText(q.getQuiz().getQuestionText())
                .options(q.getQuiz().getOptions())
                .type(q.getQuiz().getType().name())
                .userResponse(q.getUserResponse())
                .correctResponse(q.getCorrectResponse())
                .punctuation(q.getPunctuation())
                .feedbackIa(q.getFeedbackIa())
                .build();
    }
}