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
        log.info("Sending prompt to Groq for {} questions", answers.size());
        String rawJson  = groqClient.complete(prompt);

        log.info("Groq raw response (first 500 chars): {}", 
                 rawJson.substring(0, Math.min(500, rawJson.length())));

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
            log.info("Parsing Groq response for {} expected results. Raw response: {}", 
                     expectedCount, rawJson.substring(0, Math.min(200, rawJson.length())));
            
            JsonNode root = objectMapper.readTree(rawJson);
            log.debug("Successfully parsed JSON, root type: {}", root.getNodeType());
            
            JsonNode evaluations = extractEvaluationsArray(root);
            log.debug("Extracted evaluations array, size: {}", evaluations.size());

            List<EvaluationResult> results = objectMapper
                    .readerForListOf(EvaluationResult.class)
                    .readValue(evaluations);
            log.info("Successfully deserialized {} evaluation results", results.size());

            if (results.size() != expectedCount) {
                log.warn("Groq returned {} results but expected {}. Padding with fallbacks.",
                        results.size(), expectedCount);
            }

            List<EvaluationResult> final_results = padToSize(results, expectedCount);
            log.info("Returning {} final results after padding", final_results.size());
            return final_results;

        } catch (Exception e) {
            log.error("Failed to parse Groq response: {}", e.getMessage(), e);
            log.error("Raw response was: {}", rawJson);
            List<EvaluationResult> fallback = fallbackResults(expectedCount, "AI evaluation pending - parsing error");
            log.error("Returning fallback results (count: {})", fallback.size());
            return fallback;
        }
    }

    private JsonNode extractEvaluationsArray(JsonNode root) {
        // Try multiple possible structures that Groq might return
        if (root.isArray()) {
            log.debug("Root is already an array");
            return root;
        }
        if (root.has("evaluations")) {
            log.debug("Found 'evaluations' field");
            return root.get("evaluations");
        }
        if (root.has("results")) {
            log.debug("Found 'results' field");
            return root.get("results");
        }
        if (root.has("data")) {
            log.debug("Found 'data' field");
            return root.get("data");
        }
        
        // Last resort: log what we got and throw
        log.error("Cannot find evaluation array in Groq response. Root keys: {}", root.fieldNames());
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