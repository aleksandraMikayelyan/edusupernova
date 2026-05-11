package com.edusupernova.edusupernova.service;

import com.edusupernova.edusupernova.model.TestQuestions;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Locale;
import java.util.Map;

/**
 * Evaluates open-ended answers using the Groq LLM.
 * Single responsibility: prompt building + response parsing.
 * Does NOT modify entities — returns immutable results.
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class OpenEndedEvaluator {

    private final GroqService   groqClient;
    private final ObjectMapper  objectMapper = new ObjectMapper();

    public record EvaluationResult(double score, String feedback) {}

    // ── Exam profiles ─────────────────────────────────────────────────────────

    private record ExamProfile(String label, String rubric, String scoringGuide) {}

    private static final ExamProfile IELTS_PROFILE = new ExamProfile(
        "IELTS Writing",
        """
        - Task Achievement / Task Response: Does the student fully address all parts of the task? \
        Are ideas relevant, clear, and sufficiently developed?
        - Coherence & Cohesion: Is the response logically structured with clear paragraphing \
        and appropriate use of cohesive devices?
        - Lexical Resource: Range and accuracy of vocabulary, word choice, spelling, and collocation.
        - Grammatical Range & Accuracy: Variety of sentence structures and accuracy of grammar and punctuation.
        """,
        """
        Rate each of the four criteria on the IELTS band scale (0-9), compute the average band, \
        then convert to a 0-10 score by multiplying the band by 1.11 (capped at 10). \
        Band 7 = 7.8/10, band 6 = 6.7/10, band 5 = 5.6/10. \
        In feedback, state the approximate band for each criterion and the overall band.\
        """
    );

    private static final ExamProfile TOEFL_PROFILE = new ExamProfile(
        "TOEFL Writing",
        """
        - Development & Support: Are main ideas well-developed with specific, relevant details?
        - Organization: Is the essay logically organized with a clear introduction, body, and conclusion?
        - Language Use: Appropriate range and accuracy of grammar, vocabulary, and sentence variety.
        """,
        """
        Rate on the ETS TOEFL Writing scale (0-5), then multiply by 2 for the 0-10 score. \
        Score 5 = 10/10, score 4 = 8/10, score 3 = 6/10, score 2 = 4/10. \
        In feedback, state the TOEFL score equivalent and comment on each criterion.\
        """
    );

    private static final ExamProfile SAT_PROFILE = new ExamProfile(
        "SAT Essay",
        """
        Score each dimension 1-4:
        - Reading: Comprehension of the source text, central ideas, important details, and use of evidence.
        - Analysis: Quality of argument analysis, examination of evidence, reasoning, and rhetorical/stylistic elements.
        - Writing: Command of language, precise vocabulary, sentence variety, organisation, and standard conventions.
        """,
        """
        Sum the three dimension scores (range 3-12), then map to 0-10: ((sum - 3) / 9) x 10, \
        rounded to 1 decimal. Sum 12 = 10, sum 9 = 6.7, sum 6 = 3.3. \
        In feedback, give a score for each dimension and explain the reasoning.\
        """
    );

    private static final ExamProfile A_LEVEL_PROFILE = new ExamProfile(
        "A Level / AS Level",
        """
        - AO1 Knowledge & Understanding: Accurate, relevant subject knowledge and appropriate use of specialist terminology.
        - AO2 Application: Application of knowledge to the specific question; use of examples, data, or theory.
        - AO3 Analysis & Evaluation: Logical chain of analysis, evaluation of competing arguments, and balanced conclusions.
        - Quality of Written Communication: Clarity, structure, spelling, grammar, and appropriate academic register.
        """,
        """
        Score 0-10 where 8-10 = distinction level (A/A*), 6-7 = merit (B/C), 4-5 = pass (D/E), 0-3 = below pass. \
        In feedback, comment on each AO with specific, actionable suggestions for improvement.\
        """
    );

    private static final ExamProfile ACT_PROFILE = new ExamProfile(
        "ACT Writing",
        """
        Score each domain 1-6:
        - Ideas & Analysis: Depth of engagement with the issue; multiple perspectives considered and critiqued.
        - Development & Support: Elaboration of ideas with examples, reasoning, and evidence.
        - Organization: Logical sequencing of ideas; effective introduction, transitions, and conclusion.
        - Language Use & Conventions: Precision, clarity, grammar, usage, and mechanics.
        """,
        """
        Average the four domain scores (range 1-6), then map to 0-10: (average - 1) / 5 x 10, \
        rounded to 1 decimal. Average 6 = 10, average 5 = 8/10, average 4 = 6/10. \
        In feedback, give a score for each domain and note specific improvements needed.\
        """
    );

    private static final ExamProfile DEFAULT_PROFILE = new ExamProfile(
        "General",
        """
        - Relevance: Does the answer address the question directly and completely?
        - Depth: Is the response well-developed with supporting details or examples?
        - Clarity: Is the writing clear, coherent, and logically organised?
        - Language: Is vocabulary and grammar used accurately and appropriately?
        """,
        "Score 0-10 where 8-10 = excellent, 6-7 = good, 4-5 = adequate, 0-3 = insufficient."
    );

    private static final Map<String, ExamProfile> EXAM_PROFILES = Map.ofEntries(
        Map.entry("ielts",    IELTS_PROFILE),
        Map.entry("toefl",    TOEFL_PROFILE),
        Map.entry("sat",      SAT_PROFILE),
        Map.entry("a level",  A_LEVEL_PROFILE),
        Map.entry("as level", A_LEVEL_PROFILE),
        Map.entry("act",      ACT_PROFILE)
    );

    // ── Public API ────────────────────────────────────────────────────────────

    /**
     * Evaluates a batch of open-ended answers in a single Groq call,
     * using the rubric appropriate for the given exam.
     *
     * @param answers    list of open-ended TestQuestions to evaluate
     * @param examName   exam name from the course (e.g. "IELTS", "A Level")
     * @param paperName  paper name for additional context (e.g. "Writing Task 2")
     * @return list of results in the same order as the input
     */
    public List<EvaluationResult> evaluateBatch(
            List<TestQuestions> answers, String examName, String paperName) {
        if (answers.isEmpty()) return List.of();

        ExamProfile profile = detectProfile(examName);
        String prompt = buildPrompt(answers, profile, paperName);
        log.info("Sending {} prompt to Groq for {} questions (exam={})",
                profile.label(), answers.size(), examName);
        String rawJson = groqClient.complete(prompt);

        log.info("Groq raw response (first 500 chars): {}",
                rawJson.substring(0, Math.min(500, rawJson.length())));

        return parseResults(rawJson, answers.size());
    }

    // ── Private helpers ───────────────────────────────────────────────────────

    private ExamProfile detectProfile(String examName) {
        if (examName == null || examName.isBlank()) return DEFAULT_PROFILE;
        // Normalise hyphens so "A-Level" matches "a level"
        String normalised = examName.toLowerCase(Locale.ROOT).replace("-", " ");
        return EXAM_PROFILES.entrySet().stream()
                .filter(e -> normalised.contains(e.getKey()))
                .findFirst()
                .map(Map.Entry::getValue)
                .orElse(DEFAULT_PROFILE);
    }

    private String buildPrompt(List<TestQuestions> answers, ExamProfile profile, String paperName) {
        StringBuilder data = new StringBuilder();
        for (int i = 0; i < answers.size(); i++) {
            data.append(String.format("[%d] Q: %s | A: %s\n",
                    i,
                    answers.get(i).getQuiz().getQuestionText(),
                    answers.get(i).getUserResponse()));
        }

        String examLabel = paperName != null && !paperName.isBlank()
                ? profile.label() + " - " + paperName
                : profile.label();

        return String.format(
                "You are an expert %s examiner. " +
                "Evaluate the following %d written answer(s) strictly using the official rubric below.\n\n" +
                "Rubric:\n%s\n" +
                "Scoring: %s\n\n" +
                "For each answer the feedback object MUST have exactly three fields:\n" +
                "- \"strengths\": 1-2 sentences on what the candidate did well\n" +
                "- \"criteria\": object where each key is a rubric criterion and the value describes " +
                "a specific weakness found in the answer with a concrete example and how to fix it. " +
                "Only include criteria that genuinely need improvement. Be honest and direct.\n" +
                "- \"nextSteps\": 2-3 short, numbered, actionable improvements the candidate should practise\n\n" +
                "Return ONLY a valid JSON object:\n" +
                "{\"evaluations\": [{\"score\": 6.0, \"feedback\": {" +
                "\"strengths\": \"Clear position in introduction; good topic sentences.\", " +
                "\"criteria\": {" +
                "\"Coherence & Cohesion\": \"Paragraph 3 opens with 'Also' after an unrelated point — add a bridging sentence or use 'Furthermore'.\", " +
                "\"Lexical Resource\": \"'Important' appears 4 times. Vary with 'significant', 'critical', or 'pivotal'.\"}, " +
                "\"nextSteps\": \"1. Practise cohesive devices (however, therefore, consequently). 2. Build a vocabulary log and avoid repeating any content word more than once per essay.\"}}]}\n\n" +
                "Answers:\n%s",
                examLabel,
                answers.size(),
                profile.rubric(),
                profile.scoringGuide(),
                data
        );
    }

    private List<EvaluationResult> parseResults(String rawJson, int expectedCount) {
        try {
            log.info("Parsing Groq response for {} expected results. Raw response: {}",
                     expectedCount, rawJson.substring(0, Math.min(200, rawJson.length())));

            JsonNode root = objectMapper.readTree(rawJson);
            JsonNode evaluations = extractEvaluationsArray(root);
            log.debug("Extracted evaluations array, size: {}", evaluations.size());

            List<EvaluationResult> results = new java.util.ArrayList<>();
            for (JsonNode eval : evaluations) {
                double score = eval.path("score").asDouble(0.0);
                JsonNode feedbackNode = eval.path("feedback");
                // Store structured feedback as JSON string; fall back to plain text if Groq returns a string
                String feedbackJson = feedbackNode.isObject()
                        ? objectMapper.writeValueAsString(feedbackNode)
                        : feedbackNode.asText("AI evaluation unavailable.");
                results.add(new EvaluationResult(score, feedbackJson));
            }

            log.info("Successfully parsed {} evaluation results", results.size());

            if (results.size() != expectedCount) {
                log.warn("Groq returned {} results but expected {}. Padding with fallbacks.",
                        results.size(), expectedCount);
            }

            List<EvaluationResult> finalResults = padToSize(results, expectedCount);
            log.info("Returning {} final results after padding", finalResults.size());
            return finalResults;

        } catch (Exception e) {
            log.error("Failed to parse Groq response: {}", e.getMessage(), e);
            log.error("Raw response was: {}", rawJson);
            List<EvaluationResult> fallback = fallbackResults(expectedCount, "AI evaluation pending - parsing error");
            log.error("Returning fallback results (count: {})", fallback.size());
            return fallback;
        }
    }

    private JsonNode extractEvaluationsArray(JsonNode root) {
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
