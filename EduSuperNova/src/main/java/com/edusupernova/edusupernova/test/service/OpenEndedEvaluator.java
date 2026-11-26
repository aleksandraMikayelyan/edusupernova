package com.edusupernova.edusupernova.test.service;

import com.edusupernova.edusupernova.exception.GroqApiException;
import com.edusupernova.edusupernova.model.Quiz;
import com.edusupernova.edusupernova.model.QuestionGroup;
import com.edusupernova.edusupernova.model.TestQuestions;
import com.edusupernova.edusupernova.test.service.evaluation.AIEvaluationProvider;
import com.edusupernova.edusupernova.test.service.evaluation.ExamProfile;
import com.edusupernova.edusupernova.test.service.evaluation.EvaluationStrategyRegistry;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * Evaluates open-ended answers using the configured AI provider.
 *
 * Rubric selection is fully delegated to {@link EvaluationStrategyRegistry} (OCP):
 * adding a new exam type = adding a new strategy, this class never changes.
 *
 * AI transport is injected via {@link AIEvaluationProvider} (DIP):
 * switching from Groq to another provider = swapping the bean, no changes here.
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class OpenEndedEvaluator {

    private final AIEvaluationProvider       aiProvider;
    private final EvaluationStrategyRegistry strategyRegistry;
    private final ObjectMapper               objectMapper = new ObjectMapper();

    public record EvaluationResult(double score, String feedback) {}

    /** Attempts per Groq call before giving up and marking the batch pending re-evaluation. */
    private static final int    MAX_ATTEMPTS = 2;
    /** Sentinel score — mirrors EvaluationService.PENDING_SCORE so these rows read as "pending", not "failed". */
    private static final double PENDING_SCORE = -1.0;
    private static final String PENDING_REEVALUATION_FEEDBACK =
            "AI evaluation pending re-evaluation — the AI provider did not return a usable result.";

    private static final String SYSTEM_PREAMBLE =
        "You are a strict professional examiner. " +
        "Respond ONLY with a valid JSON object — no markdown, no prose, no code fences.\n" +
        "CRITICAL RULES — enforce without exception:\n" +
        "1. If an answer does not address the question asked (e.g. it discusses unrelated topics, " +
        "   contains random text, programming content, or is clearly nonsensical), " +
        "   you MUST assign score 0 and state explicitly in 'strengths' that the answer is irrelevant.\n" +
        "2. Never invent or assume knowledge the candidate did not demonstrate.\n" +
        "3. Never award marks for effort alone; award marks only for demonstrated subject knowledge.\n" +
        "4. A blank or placeholder answer scores 0.";

    // ── Public API ────────────────────────────────────────────────────────────

    public List<EvaluationResult> evaluateBatch(
            List<TestQuestions> answers, String examName, String paperName) {
        if (answers.isEmpty()) return List.of();

        ExamProfile profile = strategyRegistry.resolve(examName, paperName, answers);
        String prompt = buildPrompt(answers, profile, paperName);
        log.info("Evaluating {} answer(s) with profile '{}' (exam='{}', paper='{}')",
                answers.size(), profile.label(), examName, paperName);

        String rawJson = completeWithRetry(prompt, answers.size());
        if (rawJson == null) {
            return pendingReEvaluationResults(answers.size());
        }
        log.debug("AI raw response (first 500 chars): {}",
                rawJson.substring(0, Math.min(500, rawJson.length())));

        return parseResults(rawJson, answers.size());
    }

    // ── Transport retry ───────────────────────────────────────────────────────

    /**
     * Retries once on a Groq transport/API failure, then gives up.
     * Returns null (rather than throwing) so a transport failure and a malformed-JSON
     * response end up with the same outcome: pending re-evaluation, never a silent 0.
     */
    private String completeWithRetry(String prompt, int expectedCount) {
        for (int attempt = 1; attempt <= MAX_ATTEMPTS; attempt++) {
            try {
                return aiProvider.complete(SYSTEM_PREAMBLE, prompt);
            } catch (GroqApiException e) {
                log.warn("Groq request failed (attempt {}/{} for {} answer(s)): {}",
                        attempt, MAX_ATTEMPTS, expectedCount, e.getMessage());
            }
        }
        return null;
    }

    // ── Prompt builder ────────────────────────────────────────────────────────

    private String buildPrompt(List<TestQuestions> answers, ExamProfile profile, String paperName) {
        String examLabel = (paperName != null && !paperName.isBlank())
                ? profile.label() + " — " + paperName
                : profile.label();

        StringBuilder data = new StringBuilder();
        for (int i = 0; i < answers.size(); i++) {
            TestQuestions tq    = answers.get(i);
            Quiz          quiz  = tq.getQuiz();
            QuestionGroup group = quiz.getQuestionGroup();

            String contextLine = "";
            if (group != null && group.getContextText() != null
                    && !group.getContextText().isBlank()) {
                contextLine = "\n   [Visual/Stimulus]: " + group.getContextText().strip();
            }

            data.append(String.format(
                    "[%d] Question: %s%s\n    Answer: %s\n\n",
                    i,
                    quiz.getQuestionText().strip(),
                    contextLine,
                    tq.getUserResponse() == null ? "(no answer)" : tq.getUserResponse().strip()
            ));
        }

        return "Exam: " + examLabel + "\n\n" +
               "RUBRIC:\n" + profile.rubric() + "\n" +
               "SCORING INSTRUCTION:\n" + profile.scoringGuide() + "\n\n" +
               "For each answer return EXACTLY this JSON structure — one entry per answer:\n" +
               "{\"evaluations\": [{\n" +
               "  \"score\": 6.0,\n" +
               "  \"feedback\": {\n" +
               "    \"strengths\": \"1–2 sentences on what the candidate did well.\",\n" +
               "    \"criteria\": {\n" +
               "      \"<Criterion name>\": \"Specific weakness with a concrete example and how to fix it.\"\n" +
               "    },\n" +
               "    \"nextSteps\": \"1. Actionable improvement. 2. Actionable improvement.\"\n" +
               "  }\n" +
               "}]}\n\n" +
               "ANSWERS TO EVALUATE:\n" + data;
    }

    // ── Response parsing ──────────────────────────────────────────────────────

    private List<EvaluationResult> parseResults(String rawJson, int expectedCount) {
        try {
            JsonNode root        = objectMapper.readTree(rawJson);
            JsonNode evaluations = extractEvaluationsArray(root);

            List<EvaluationResult> results = new java.util.ArrayList<>();
            for (JsonNode eval : evaluations) {
                double   score        = eval.path("score").asDouble(0.0);
                JsonNode feedbackNode = eval.path("feedback");
                String   feedbackJson = feedbackNode.isObject()
                        ? objectMapper.writeValueAsString(feedbackNode)
                        : feedbackNode.asText("AI evaluation unavailable.");
                results.add(new EvaluationResult(score, feedbackJson));
            }

            if (results.size() != expectedCount) {
                log.warn("AI returned {} results but expected {}. Padding with pending placeholders.",
                        results.size(), expectedCount);
            }

            return padToSize(results, expectedCount);

        } catch (Exception e) {
            log.error("Failed to parse AI response, marking batch pending re-evaluation: {}", e.getMessage());
            return pendingReEvaluationResults(expectedCount);
        }
    }

    private JsonNode extractEvaluationsArray(JsonNode root) {
        if (root.isArray())          return root;
        if (root.has("evaluations")) return root.get("evaluations");
        if (root.has("results"))     return root.get("results");
        if (root.has("data"))        return root.get("data");
        throw new IllegalStateException("Unexpected AI JSON structure: " + root);
    }

    private List<EvaluationResult> padToSize(List<EvaluationResult> results, int targetSize) {
        if (results.size() >= targetSize) return results.subList(0, targetSize);
        var padded = new java.util.ArrayList<>(results);
        while (padded.size() < targetSize)
            padded.add(new EvaluationResult(PENDING_SCORE, "No evaluation returned for this answer — pending re-evaluation."));
        return padded;
    }

    private List<EvaluationResult> pendingReEvaluationResults(int count) {
        return java.util.Collections.nCopies(count, new EvaluationResult(PENDING_SCORE, PENDING_REEVALUATION_FEEDBACK));
    }
}
