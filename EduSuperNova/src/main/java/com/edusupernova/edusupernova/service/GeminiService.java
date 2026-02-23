package com.edusupernova.edusupernova.service;

import com.edusupernova.edusupernova.model.TestQuestions;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.util.List;

@Service
public class GeminiService {

    @Value("${groq.api.key}")
    private String apiKey;

    private final HttpClient httpClient = HttpClient.newHttpClient();
    private final ObjectMapper objectMapper = new ObjectMapper();

    public List<EvaluationResult> evaluarLoteCompleto(List<TestQuestions> answers, String context) {
        try {
            // Build a string representing all user answers
            StringBuilder batchData = new StringBuilder();
            for (int i = 0; i < answers.size(); i++) {
                batchData.append(String.format("[%d] Q: %s | A: %s\n",
                        i, answers.get(i).getQuiz().getQuestionText(), answers.get(i).getUserResponse()));
            }

            String prompt = """
                Act as an expert examiner for %s. Rate these %d answers from 0 to 10.
                Return ONLY a JSON array of objects with "puntuacion" (double) and "feedback" (string).
                
                Data:
                %s
                """.formatted(context, answers.size(), batchData.toString());

            // Simple helper to escape quotes for the JSON body
            String safePrompt = prompt.replace("\"", "\\\"").replace("\n", "\\n");

            String jsonBody = """
                {
                  "model": "llama-3.1-70b-versatile",
                  "messages": [{"role": "user", "content": "%s"}],
                  "response_format": { "type": "json_object" },
                  "temperature": 0.3
                }
                """.formatted(safePrompt);

            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create("https://api.groq.com/openai/v1/chat/completions"))
                    .header("Content-Type", "application/json")
                    .header("Authorization", "Bearer " + apiKey)
                    .POST(HttpRequest.BodyPublishers.ofString(jsonBody))
                    .build();

            HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());

            // Parsing the list from the AI response
            JsonNode root = objectMapper.readTree(response.body());
            String content = root.path("choices").get(0).path("message").path("content").asText();

            // If LLM wraps the array in a field like "evaluations": [ ... ]
            JsonNode resultsNode = objectMapper.readTree(content);
            if (resultsNode.isObject() && resultsNode.has("evaluations")) {
                resultsNode = resultsNode.get("evaluations");
            }

            return objectMapper.readerForListOf(EvaluationResult.class).readValue(resultsNode);

        } catch (Exception e) {
            // Fallback for all if AI fails
            return answers.stream()
                    .map(a -> new EvaluationResult(0.0, "Evaluation failed: " + e.getMessage()))
                    .toList();
        }
    }

    public record EvaluationResult(double puntuacion, String feedback) {
        public double getPuntuacion() { return puntuacion; }
        public String getFeedback() { return feedback; }
    }
}
//Api key= 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