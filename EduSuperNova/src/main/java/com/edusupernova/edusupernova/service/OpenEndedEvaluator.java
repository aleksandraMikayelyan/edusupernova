package com.edusupernova.edusupernova.service;

import com.edusupernova.edusupernova.model.TestQuestions;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * Evaluates open-ended answers using the Groq LLM.
 * Single responsibility: prompt building + response parsing.
 * Does NOT modify entities — returns immutable results.
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class OpenEndedEvaluator {

    private final GroqService    groqClient;
    private final ObjectMapper  objectMapper = new ObjectMapper();

    public record EvaluationResult(double score, String feedback) {}

    /**
     * Evaluates a batch of open-ended answers in a single Groq call.
     *
     * @param answers  list of open-ended TestQuestions to evaluate
     * @param context  exam context (e.g. "Economics — A Level")
     * @return list of results in the same order as the input
     */
    public List<EvaluationResult> evaluateBatch(List<TestQuestions> answers, String context) {
        if (answers.isEmpty()) return List.of();

        String prompt   = buildPrompt(answers, context);
        String rawJson  = groqClient.complete(prompt);

        log.debug("Groq raw response: {}", rawJson);

        return parseResults(rawJson, answers.size());
    }

    // ── Private helpers ──────────────────────────────────────────────────────

    private String buildPrompt(List<TestQuestions> answers, String context) {
        StringBuilder data = new StringBuilder();
        for (int i = 0; i < answers.size(); i++) {
            data.append(String.format("[%d] Q: %s | A: %s\n",
                    i,
                    answers.get(i).getQuiz().getQuestionText(),
                    answers.get(i).getUserResponse()));
        }

        return String.format(
                "Act as an expert examiner for %s. " +
                        "Rate these %d open-ended answers from 0 to 10. " +
                        "Return ONLY a valid JSON object with field \"evaluations\" containing an array. " +
                        "Each element must have \"score\" (number 0-10) and \"feedback\" (string). " +
                        "Example: {\"evaluations\": [{\"score\": 7.5, \"feedback\": \"Good answer.\"}]}\n\n" +
                        "Data:\n%s",
                context, answers.size(), data
        );
    }

    private List<EvaluationResult> parseResults(String rawJson, int expectedCount) {
        try {
            JsonNode root = objectMapper.readTree(rawJson);
            JsonNode evaluations = extractEvaluationsArray(root);

            List<EvaluationResult> results = objectMapper
                    .readerForListOf(EvaluationResult.class)
                    .readValue(evaluations);

            if (results.size() != expectedCount) {
                log.warn("Groq returned {} results but expected {}. Padding with fallbacks.",
                        results.size(), expectedCount);
            }

            return padToSize(results, expectedCount);

        } catch (Exception e) {
            log.error("Failed to parse Groq response: {}", e.getMessage());
            return fallbackResults(expectedCount, "Parsing failed: " + e.getMessage());
        }
    }

    private JsonNode extractEvaluationsArray(JsonNode root) {
        if (root.isArray())                    return root;
        if (root.has("evaluations"))           return root.get("evaluations");
        if (root.has("results"))               return root.get("results");
        throw new IllegalStateException("Unexpected Groq JSON structure: " + root);
    }

    private List<EvaluationResult> padToSize(List<EvaluationResult> results, int targetSize) {
        if (results.size() >= targetSize) return results.subList(0, targetSize);

        var padded = new java.util.ArrayList<>(results);
        while (padded.size() < targetSize) {
            padded.add(new EvaluationResult(0.0, "No evaluation returned for this answer."));
        }
        return padded;
    }

    private List<EvaluationResult> fallbackResults(int count, String reason) {
        return java.util.Collections.nCopies(count, new EvaluationResult(0.0, reason));
    }
}