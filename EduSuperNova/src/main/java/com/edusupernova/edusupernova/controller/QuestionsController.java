package com.edusupernova.edusupernova.controller;

import com.edusupernova.edusupernova.model.Quiz;
import com.edusupernova.edusupernova.service.QuizService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * REST controller for quiz question operations.
 *
 * SRP – only handles HTTP mapping; question selection logic lives in
 *       {@link QuizService}.
 */
@RestController
@RequestMapping("/api/questions")
@RequiredArgsConstructor
public class QuestionsController {

    private final QuizService quizService;

    /**
     * Generates and returns a randomised test for the given course
     * (15 multiple-choice + 5 open-ended questions).
     *
     * Returns {@code 400 Bad Request} with a stats message when the
     * course question bank does not have enough questions.
     */
    @GetMapping("/generate/{courseId}")
    public ResponseEntity<?> generateTest(@PathVariable int courseId) {
        if (!quizService.canGenerateTest(courseId)) {
            return ResponseEntity.badRequest()
                    .body("Not enough questions to generate a balanced test. "
                            + quizService.getQuestionStats(courseId));
        }

        List<Quiz> questions = quizService.generateRandomTest(courseId);
        return ResponseEntity.ok(questions);
    }

    /** Returns a human-readable summary of available questions for a course. */
    @GetMapping("/stats/{courseId}")
    public ResponseEntity<String> getStats(@PathVariable int courseId) {
        return ResponseEntity.ok(quizService.getQuestionStats(courseId));
    }
}