package com.edusupernova.edusupernova.service;

import com.edusupernova.edusupernova.data.TestQuestionsRepository;
import com.edusupernova.edusupernova.model.TestQuestions;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional
public class EvaluationService {

    private final TestQuestionsRepository testQuestionRepo;
    private final GeminiService groqService;  // o GeminiService / LlmService

    // Ponderaciones (puedes mover a application.properties)
    private static final double MULTIPLE_CHOICE_WEIGHT = 0.70;
    private static final double OPEN_ENDED_WEIGHT = 0.30;
    private static final int MAX_SCORE_MULTIPLE = 15;     // 15 preguntas × 1 punto
    private static final int MAX_SCORE_OPEN_ENDED = 50;   // ej: 5 preguntas × 10 puntos

    /**
     * Evalúa todo el test y actualiza la base de datos
     * @return Resultado global con puntuación y feedback
     */
    public TestEvaluationResult evaluateTest(Integer testId) {
        List<TestQuestions> allAnswers = testQuestionRepo.findByIdTestId(testId);

        if (allAnswers.isEmpty()) {
            throw new IllegalStateException("No hay respuestas para evaluar en el test " + testId);
        }

        // 1. Evaluar multiple choice (automático)
        long correctMultiple = allAnswers.stream()
                .filter(a -> "multipleChoice".equals(a.getQuiz().getType()))
                .filter(TestQuestions::getCorrectResponse)
                .count();

        double scoreMultiple = (double) correctMultiple / MAX_SCORE_MULTIPLE * 100 * MULTIPLE_CHOICE_WEIGHT;

        // 2. Evaluar open-ended (con LLM)
        List<TestQuestions> openEndedAnswers = allAnswers.stream()
                .filter(a -> List.of("openEnded", "logicalProblems").contains(a.getQuiz().getType()))
                .toList();

        double totalOpenScore = 0.0;
        StringBuilder feedbackBuilder = new StringBuilder();

        for (TestQuestions answer : openEndedAnswers) {
            String questionText = answer.getQuiz().getQuestionText();
            String userResponse = answer.getUserResponse();

            GeminiService.EvaluationResult llmResult = groqService.evaluarRespuestaAbierta(questionText, userResponse);

            double openScore = llmResult.getPuntuacion(); // 0-10
            totalOpenScore += openScore;

            // Guardamos en BD
            answer.setPunctuation((int) Math.round(openScore));
            answer.setFeedbackIa(llmResult.getFeedback());
            answer.setCorrectResponse(openScore >= 6.0); // umbral ejemplo

            feedbackBuilder.append("Pregunta: ").append(questionText).append("\n")
                    .append("Tu respuesta: ").append(userResponse).append("\n")
                    .append("Puntuación: ").append(openScore).append("/10\n")
                    .append("Feedback: ").append(llmResult.getFeedback()).append("\n\n");
        }

        // Normalizamos open-ended a porcentaje
        double normalizedOpenScore = (totalOpenScore / (openEndedAnswers.size() * 10.0)) * 100 * OPEN_ENDED_WEIGHT;

        // 3. Puntuación global
        double totalScore = scoreMultiple + normalizedOpenScore;

        // 4. Guardar puntuación final en Tests (si tienes campo)
        // Tests test = testRepo.findById(testId).orElseThrow();
        // test.setPunctuation((int) Math.round(totalScore));
        // testRepo.save(test);

        // 5. Resultado consolidado
        return new TestEvaluationResult(
                totalScore,
                scoreMultiple,
                normalizedOpenScore,
                feedbackBuilder.toString()
        );
    }

    // DTO simple para devolver al controlador / frontend
    public record TestEvaluationResult(
            double totalScore,          // 0-100
            double multipleChoiceScore, // porcentaje ponderado
            double openEndedScore,      // porcentaje ponderado
            String detailedFeedback     // texto con todas las correcciones
    ) {}
}
