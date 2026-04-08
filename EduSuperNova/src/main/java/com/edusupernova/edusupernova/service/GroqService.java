package com.edusupernova.edusupernova.service;
import com.edusupernova.edusupernova.exception.GroqApiException;
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
public class GroqService {

    private static final String GROQ_URL = "https://api.groq.com/openai/v1/chat/completions";
    private static final String MODEL    = "llama-3.3-70b-versatile";

    @Value("${groq.api.key}")
    private String apiKey;

    private final HttpClient    httpClient    = HttpClient.newHttpClient();
    private final ObjectMapper  objectMapper  = new ObjectMapper();

    /**
     * Sends a prompt to Groq and returns the plain-text content of the first choice.
     *
     * @param prompt the user message to send
     * @return raw text content from the model
     * @throws GroqApiException if Groq returns an error or an unexpected response
     */
    public String complete(String prompt) {
        try {
            String requestBody = buildRequestBody(prompt);

            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(GROQ_URL))
                    .header("Content-Type", "application/json")
                    .header("Authorization", "Bearer " + apiKey)
                    .POST(HttpRequest.BodyPublishers.ofString(requestBody))
                    .build();

            HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());

            return extractContent(response.body());

        } catch (GroqApiException e) {
            throw e;
        } catch (Exception e) {
            throw new GroqApiException("HTTP request to Groq failed: " + e.getMessage(), e);
        }
    }

    private String buildRequestBody(String prompt) throws Exception {
        // Use ObjectMapper to safely escape the prompt inside JSON
        String escapedPrompt = objectMapper.writeValueAsString(prompt);
        return String.format(
                "{\"model\": \"%s\", " +
                        "\"messages\": [{\"role\": \"user\", \"content\": %s}], " +
                        "\"response_format\": {\"type\": \"json_object\"}, " +
                        "\"temperature\": 0.3}",
                MODEL, escapedPrompt
        );
    }

    private String extractContent(String responseBody) throws Exception {
        JsonNode root = objectMapper.readTree(responseBody);

        if (root.has("error")) {
            String message = root.path("error").path("message").asText("Unknown Groq error");
            throw new GroqApiException("Groq API error: " + message);
        }

        JsonNode choices = root.path("choices");
        if (!choices.isArray() || choices.isEmpty()) {
            throw new GroqApiException("Groq returned no choices. Response: " + responseBody);
        }

        return choices.get(0).path("message").path("content").asText();
    }

}
