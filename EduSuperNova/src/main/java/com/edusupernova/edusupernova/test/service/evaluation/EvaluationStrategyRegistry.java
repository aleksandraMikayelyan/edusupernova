package com.edusupernova.edusupernova.test.service.evaluation;

import com.edusupernova.edusupernova.model.TestQuestions;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 * Selects the appropriate evaluation rubric by iterating strategies in @Order sequence.
 * Adding a new exam type = adding a new @Component strategy; this class never changes.
 */
@Component
@RequiredArgsConstructor
public class EvaluationStrategyRegistry {

    private final List<EvaluationStrategy> strategies;

    public ExamProfile resolve(String examName, String paperName, List<TestQuestions> answers) {
        return strategies.stream()
                .filter(s -> s.supports(examName, paperName, answers))
                .findFirst()
                .map(EvaluationStrategy::profile)
                .orElseThrow(() -> new IllegalStateException(
                        "No evaluation strategy matched — DefaultEvaluationStrategy should always match"));
    }
}
