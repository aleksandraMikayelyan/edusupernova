package com.edusupernova.edusupernova.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

@Service  // ← Esto es lo que faltaba
public class GeminiService {  // Puedes renombrarla a GroqService si prefieres ser más preciso

    // ¡IMPORTANTE! Nunca dejes la API key hardcodeada en el código
    // Mejor usa application.properties o variables de entorno
    @Value("${groq.api.key}")  // ← lee de application.properties o .env
    private String apiKey;

    private final HttpClient httpClient = HttpClient.newHttpClient();
    private final ObjectMapper objectMapper = new ObjectMapper();

    public EvaluationResult evaluarRespuestaAbierta(String pregunta, String respuestaUser) {
        try {
            String prompt = """
                Eres un profesor evaluando respuestas abiertas de estudiantes.
                Evalúa la siguiente respuesta en una escala de 0 a 10.

                Pregunta: %s
                Respuesta del estudiante: %s

                Criterios: corrección conceptual, profundidad, claridad, relevancia.

                Responde SOLO con este JSON exacto:
                {
                  "puntuacion": 8.5,
                  "feedback": "Muy buena explicación del concepto principal, pero faltó mencionar...",
                  "conceptos_faltantes": ["ejemplo concreto", "impacto ambiental"]
                }
                """.formatted(pregunta, respuestaUser);

            String jsonBody = """
                {
                  "model": "llama-3.1-70b-versatile",
                  "messages": [
                    {"role": "user", "content": "%s"}
                  ],
                  "temperature": 0.7,
                  "max_tokens": 300
                }
                """.formatted(prompt.replace("\"", "\\\""));

            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create("https://api.groq.com/openai/v1/chat/completions"))
                    .header("Content-Type", "application/json")
                    .header("Authorization", "Bearer " + apiKey)
                    .POST(HttpRequest.BodyPublishers.ofString(jsonBody))
                    .build();

            HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());

            if (response.statusCode() != 200) {
                throw new RuntimeException("Error en Groq: HTTP " + response.statusCode() + " - " + response.body());
            }

            JsonNode root = objectMapper.readTree(response.body());
            String textoRespuesta = root.path("choices").get(0).path("message").path("content").asText();

            JsonNode json = objectMapper.readTree(textoRespuesta);

            double puntuacion = json.get("puntuacion").asDouble();
            String feedback = json.get("feedback").asText();

            return new EvaluationResult(puntuacion, feedback);

        } catch (Exception e) {
            System.err.println("Error al evaluar con Groq: " + e.getMessage());
            return new EvaluationResult(0.0, "No se pudo evaluar la respuesta en este momento.");
        }
    }

    public static class EvaluationResult {
        private final double puntuacion;
        private final String feedback;

        public EvaluationResult(double puntuacion, String feedback) {
            this.puntuacion = puntuacion;
            this.feedback = feedback;
        }

        public double getPuntuacion() { return puntuacion; }
        public String getFeedback() { return feedback; }

        @Override
        public String toString() {
            return "Puntuación: " + puntuacion + "/10\nFeedback: " + feedback;
        }
    }
}
//Api key= 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