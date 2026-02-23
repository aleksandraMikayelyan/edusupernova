package com.edusupernova.edusupernova.controller;

import com.edusupernova.edusupernova.model.Quiz;
import com.edusupernova.edusupernova.service.QuizService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/questions")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class QuestionsController {

    private final QuizService quizService;

    @GetMapping("/generate/{courseId}")
    public ResponseEntity<?> getTestQuestions(@PathVariable int courseId) {
        // 1. Check if we have enough questions in the DB
        if (!quizService.canGenerateTest(courseId)) {
            return ResponseEntity.badRequest()
                    .body("Not enough questions to generate a balanced test. " +
                            quizService.getQuestionStats(courseId));
        }

        // 2. Return the random selection
        List<Quiz> questions = quizService.generateRandomTest(courseId);
        return ResponseEntity.ok(questions);
    }

    @GetMapping("/stats/{courseId}")
    public ResponseEntity<String> getStats(@PathVariable int courseId) {
        return ResponseEntity.ok(quizService.getQuestionStats(courseId));
    }
}
