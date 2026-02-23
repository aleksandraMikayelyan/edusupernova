package com.edusupernova.edusupernova.service;

import com.edusupernova.edusupernova.data.TestQuestionsRepository;
import com.edusupernova.edusupernova.model.TestQuestions;
import com.edusupernova.edusupernova.service.GeminiService;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;


import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class EvaluationService {

    private final TestQuestionsRepository testQuestionRepo;
    private final GeminiService groqService;

    // Weights for final score calculation
    private static final double MC_WEIGHT = 0.70;
    private static final double OPEN_WEIGHT = 0.30;

    public TestEvaluationResult evaluateTest(Integer testId, String examType, String sectionName) {
        List<TestQuestions> allAnswers = testQuestionRepo.findByIdTestId(testId);
        if (allAnswers.isEmpty()) throw new IllegalStateException("No answers for test: " + testId);

        // 1. Evaluate Multiple Choice
        List<TestQuestions> mcQuestions = allAnswers.stream()
                .filter(a -> "multipleChoice".equals(a.getQuiz().getType()))
                .toList();

        long correctCount = mcQuestions.stream().filter(TestQuestions::getCorrectResponse).count();
        double scoreMC = mcQuestions.isEmpty() ? 0 : ((double) correctCount / mcQuestions.size()) * 10.0;

        // 2. Evaluate Open-Ended (Batch)
        List<TestQuestions> openQuestions = allAnswers.stream()
                .filter(a -> List.of("openEnded", "speaking", "writing").contains(a.getQuiz().getType()))
                .toList();

        double totalOpenScore = 0;
        StringBuilder feedbackBuilder = new StringBuilder();

        if (!openQuestions.isEmpty()) {
            String context = String.format("Exam: %s, Section: %s", examType, sectionName);
            List<GeminiService.EvaluationResult> results = groqService.evaluarLoteCompleto(openQuestions, context);

            for (int i = 0; i < openQuestions.size(); i++) {
                TestQuestions q = openQuestions.get(i);
                GeminiService.EvaluationResult res = results.get(i);

                q.setPunctuation((int) Math.round(res.getPuntuacion()));
                q.setFeedbackIa(res.getFeedback());
                q.setCorrectResponse(res.getPuntuacion() >= 6.0);

                totalOpenScore += res.getPuntuacion();
                feedbackBuilder.append("- ").append(q.getQuiz().getQuestionText()).append(": ").append(res.getFeedback()).append("\n");
            }
        }

        double avgOpenScore = openQuestions.isEmpty() ? 0 : (totalOpenScore / openQuestions.size());

        // 3. Final Calculation (Scale 0-10)
        double finalScore = (scoreMC * MC_WEIGHT) + (avgOpenScore * OPEN_WEIGHT);

        return new TestEvaluationResult(
                finalScore,
                scoreMC,
                avgOpenScore,
                feedbackBuilder.toString()
        );
    }

    public record TestEvaluationResult(double totalScore, double mcScore, double openScore, String feedback) {}
}