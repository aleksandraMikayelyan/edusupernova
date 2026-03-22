package com.edusupernova.edusupernova.service;

import com.edusupernova.edusupernova.data.TestQuestionsRepository;
import com.edusupernova.edusupernova.model.Quiz;
import com.edusupernova.edusupernova.model.TestQuestions;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.concurrent.CompletableFuture;
import java.util.stream.IntStream;

/**
 * Orchestrates the full test evaluation:
 *
 *  PHASE 1 (synchronous, always runs):
 *    - Score ALL multiple-choice questions by comparing against the
 *      correct_answer column in the DB. No AI involved whatsoever.
 *    - Persist MC results immediately so they are never lost.
 *
 *  PHASE 2 (asynchronous, runs independently):
 *    - Score open-ended / logical-problem questions via Groq AI.
 *    - Persisted separately once AI responds; failures do NOT affect MC scores.
 *
 *  POLLING:
 *    - buildResultFromPersistedRows() re-assembles the current DB state
 *      without triggering any new evaluation — used by GET /api/feedback/{testId}.
 *
 *  This split guarantees:
 *    • MC feedback is instant and deterministic.
 *    • A Groq outage/restriction never blocks or rolls back MC results.
 *    • The frontend can render MC results immediately and poll for AI results.
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class EvaluationService {

    // ── Weights only matter when BOTH question types exist in a test ──────────
    private static final double MC_WEIGHT   = 0.70;
    private static final double OPEN_WEIGHT = 0.30;

    /** Sentinel value: score == -1 means "AI has not evaluated this row yet". */
    private static final int PENDING_SCORE = -1;

    /** Groq sets this placeholder in feedbackIa while async evaluation is in flight. */
    private static final String PENDING_FEEDBACK = "AI evaluation in progress...";

    private static final Set<Quiz.QuestionType> OPEN_ENDED_TYPES = Set.of(
            Quiz.QuestionType.OPEN_ENDED,
            Quiz.QuestionType.LOGICAL_PROBLEMS
    );

    private final TestQuestionsRepository testQuestionRepo;
    private final OpenEndedEvaluator      openEndedEvaluator;

    // ─────────────────────────────────────────────────────────────────────────
    // Public DTOs
    // ─────────────────────────────────────────────────────────────────────────

    public record QuestionResult(
            int               questionId,
            String            questionText,
            Quiz.QuestionType type,
            String            userResponse,
            String            correctAnswer,
            boolean           isCorrect,
            String            feedback,
            double            score           // -1.0 == pending
    ) {}

    /**
     * Returned immediately after Phase 1.
     * {@code openEndedPending} tells the frontend whether to poll for AI results.
     */
    public record TestEvaluationResult(
            double               mcScore,
            double               openScore,
            double               totalScore,
            boolean              openEndedPending,
            List<QuestionResult> questionResults
    ) {}

    // ─────────────────────────────────────────────────────────────────────────
    // PHASE 1 — Multiple-Choice  (synchronous, @Transactional)
    // ─────────────────────────────────────────────────────────────────────────

    /**
     * Entry point called by the controller on test submission.
     * Returns instantly with MC results; triggers async AI evaluation if needed.
     */
    @Transactional
    public TestEvaluationResult evaluateTest(Integer testId, String examType, String sectionName) {

        List<TestQuestions> allAnswers  = loadAnswers(testId);
        List<TestQuestions> mcAnswers   = filterByType(allAnswers, Quiz.QuestionType.MULTIPLE_CHOICE);
        List<TestQuestions> openAnswers = filterByTypes(allAnswers, OPEN_ENDED_TYPES);

        // ── 1. Score MC questions — pure DB comparison, zero AI ──────────────
        List<QuestionResult> mcResults = evaluateMultipleChoice(mcAnswers);

        // ── 2. Persist MC flags immediately inside THIS transaction ───────────
        persistMultipleChoiceResults(mcAnswers, mcResults);

        double  mcScore      = averageScore(mcResults);
        boolean hasPendingAI = !openAnswers.isEmpty();

        // ── 3. Mark open-ended rows as pending in the DB ──────────────────────
        //    This lets buildResultFromPersistedRows() detect them correctly
        //    on subsequent polling calls before Groq has responded.
        if (hasPendingAI) {
            markOpenEndedAsPending(openAnswers);
        }

        // ── 4. Fire-and-forget Groq evaluation ───────────────────────────────
        if (hasPendingAI) {
            triggerAsyncOpenEndedEvaluation(testId, openAnswers, examType, sectionName);
        }

        // ── 5. Build partial result list ─────────────────────────────────────
        List<QuestionResult> pendingOpenResults = buildPendingPlaceholders(openAnswers);
        List<QuestionResult> allResults         = mergeResults(mcResults, pendingOpenResults);

        double totalScore = hasPendingAI ? mcScore * MC_WEIGHT : mcScore;

        log.info("Test {} Phase-1 complete — MC score: {}, open-ended pending: {}",
                testId, mcScore, hasPendingAI);

        return new TestEvaluationResult(mcScore, 0.0, totalScore, hasPendingAI, allResults);
    }

    // ─────────────────────────────────────────────────────────────────────────
    // POLLING — Rebuild result from current DB state (no new evaluation)
    //
    // Called by GET /api/feedback/{testId} every 4 s from FeedbackPage.
    // Reads whatever is currently persisted; once Groq finishes writing,
    // open-ended rows will have real scores and openEndedPending → false.
    // ─────────────────────────────────────────────────────────────────────────

    public TestEvaluationResult buildResultFromPersistedRows(
            Integer testId,
            List<TestQuestions> answers) {

        List<QuestionResult> results = answers.stream()
                .map(this::toQuestionResult)
                .toList();

        // A row is still pending if punctuation == PENDING_SCORE (-1)
        // OR feedbackIa still contains the placeholder text.
        boolean openEndedPending = results.stream()
                .anyMatch(r -> r.score() < 0
                        || PENDING_FEEDBACK.equals(r.feedback()));

        List<QuestionResult> mcResults   = results.stream()
                .filter(r -> r.type() == Quiz.QuestionType.MULTIPLE_CHOICE)
                .toList();
        List<QuestionResult> openResults = results.stream()
                .filter(r -> OPEN_ENDED_TYPES.contains(r.type()))
                .toList();

        double mcScore   = averageScore(mcResults);
        double openScore = openEndedPending ? 0.0 : averageScore(openResults);
        double total     = openResults.isEmpty()
                ? mcScore
                : mcScore * MC_WEIGHT + openScore * OPEN_WEIGHT;

        return new TestEvaluationResult(mcScore, openScore, total, openEndedPending, results);
    }

    /** Converts a persisted TestQuestions row to a QuestionResult DTO. */
    private QuestionResult toQuestionResult(TestQuestions row) {
        Quiz              quiz  = row.getQuiz();
        Quiz.QuestionType type  = quiz != null ? quiz.getType() : Quiz.QuestionType.MULTIPLE_CHOICE;
        boolean           isMC  = type == Quiz.QuestionType.MULTIPLE_CHOICE;

        // punctuation column stores -1 while pending, 0–10 once scored
        int storedScore = row.getPunctuation() != null ? row.getPunctuation() : PENDING_SCORE;
        String feedback = row.getFeedbackIa() != null ? row.getFeedbackIa() : PENDING_FEEDBACK;
        boolean pending = storedScore == PENDING_SCORE || PENDING_FEEDBACK.equals(feedback);

        return new QuestionResult(
                quiz != null ? quiz.getId() : 0,
                quiz != null ? quiz.getQuestionText() : "",
                type,
                row.getUserResponse(),
                isMC && quiz != null ? quiz.getCorrectAnswer() : null, // no "correct" for open-ended
                row.getCorrectResponse() != null && row.getCorrectResponse(),
                feedback,
                pending ? -1.0 : storedScore
        );
    }

    // ─────────────────────────────────────────────────────────────────────────
    // PHASE 2 — Open-Ended / AI  (async, separate transaction)
    // ─────────────────────────────────────────────────────────────────────────

    @Async("virtualThreadExecutor")
    public CompletableFuture<Void> triggerAsyncOpenEndedEvaluation(
            Integer             testId,
            List<TestQuestions> openAnswers,
            String              examType,
            String              sectionName) {

        try {
            log.info("Test {} — starting async Groq evaluation for {} open-ended questions",
                    testId, openAnswers.size());

            String context = buildContext(examType, sectionName);

            List<OpenEndedEvaluator.EvaluationResult> aiResults =
                    openEndedEvaluator.evaluateBatch(openAnswers, context);

            persistOpenEndedResults(openAnswers, aiResults);

            log.info("Test {} — Groq evaluation complete and persisted", testId);

        } catch (Exception ex) {
            log.error("Test {} — Groq evaluation failed (MC results unaffected): {}",
                    testId, ex.getMessage(), ex);
        }

        return CompletableFuture.completedFuture(null);
    }

    // ─────────────────────────────────────────────────────────────────────────
    // MC evaluation
    // ─────────────────────────────────────────────────────────────────────────

    private List<QuestionResult> evaluateMultipleChoice(List<TestQuestions> answers) {
        return answers.stream().map(this::scoreOneMultipleChoice).toList();
    }

    private QuestionResult scoreOneMultipleChoice(TestQuestions answer) {
        // extractLetter() handles both "D" and "D) Full text..." formats
        String userResponse  = extractLetter(answer.getUserResponse());
        String correctAnswer = extractLetter(answer.getQuiz().getCorrectAnswer());

        boolean isCorrect = !userResponse.isBlank()
                && !correctAnswer.isBlank()
                && userResponse.equalsIgnoreCase(correctAnswer);

        double score    = isCorrect ? 10.0 : 0.0;
        String feedback = isCorrect
                ? "Correct!"
                : "Incorrect. The correct answer was: " + correctAnswer;

        return new QuestionResult(
                answer.getQuiz().getId(),
                answer.getQuiz().getQuestionText(),
                Quiz.QuestionType.MULTIPLE_CHOICE,
                answer.getUserResponse(),
                answer.getQuiz().getCorrectAnswer(),
                isCorrect,
                feedback,
                score
        );
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Persistence helpers
    // ─────────────────────────────────────────────────────────────────────────

    /** Called inside Phase-1 @Transactional — committed immediately. */
    private void persistMultipleChoiceResults(
            List<TestQuestions> answers,
            List<QuestionResult> results) {

        IntStream.range(0, answers.size()).forEach(i -> {
            TestQuestions  q      = answers.get(i);
            QuestionResult result = results.get(i);
            q.setCorrectResponse(result.isCorrect());
            q.setPunctuation(result.isCorrect() ? 10 : 0);
            q.setFeedbackIa(result.feedback());
        });
        // JPA dirty-checking flushes on Phase-1 commit
    }

    /**
     * Writes PENDING_SCORE and PENDING_FEEDBACK to open-ended rows so the
     * polling endpoint can detect them correctly before Groq responds.
     * Called inside Phase-1 @Transactional — committed before returning to client.
     */
    private void markOpenEndedAsPending(List<TestQuestions> openAnswers) {
        openAnswers.forEach(q -> {
            q.setPunctuation(PENDING_SCORE);
            q.setFeedbackIa(PENDING_FEEDBACK);
            q.setCorrectResponse(false);
        });
    }

    /** Called from async method — needs its own @Transactional context. */
    @Transactional(jakarta.transaction.Transactional.TxType.REQUIRES_NEW)
    public void persistOpenEndedResults(
            List<TestQuestions> answers,
            List<OpenEndedEvaluator.EvaluationResult> aiResults) {

        IntStream.range(0, answers.size()).forEach(i -> {
            TestQuestions q  = answers.get(i);
            var           ai = aiResults.get(i);
            q.setPunctuation((int) Math.round(ai.score()));
            q.setFeedbackIa(ai.feedback());
            q.setCorrectResponse(ai.score() >= 6.0);
        });
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Utility helpers
    // ─────────────────────────────────────────────────────────────────────────

    private List<TestQuestions> loadAnswers(Integer testId) {
        List<TestQuestions> answers = testQuestionRepo.findByIdTestId(testId);
        if (answers.isEmpty()) {
            throw new IllegalStateException("No answers found for testId: " + testId);
        }
        return answers;
    }

    private List<TestQuestions> filterByType(List<TestQuestions> answers, Quiz.QuestionType type) {
        return answers.stream()
                .filter(a -> a.getQuiz() != null && type == a.getQuiz().getType())
                .toList();
    }

    private List<TestQuestions> filterByTypes(List<TestQuestions> answers, Set<Quiz.QuestionType> types) {
        return answers.stream()
                .filter(a -> a.getQuiz() != null && types.contains(a.getQuiz().getType()))
                .toList();
    }

    private List<QuestionResult> buildPendingPlaceholders(List<TestQuestions> openAnswers) {
        return openAnswers.stream()
                .map(a -> new QuestionResult(
                        a.getQuiz().getId(),
                        a.getQuiz().getQuestionText(),
                        a.getQuiz().getType(),
                        a.getUserResponse(),
                        null,
                        false,
                        PENDING_FEEDBACK,
                        -1.0
                ))
                .toList();
    }

    private double averageScore(List<QuestionResult> results) {
        if (results.isEmpty()) return 0.0;
        return results.stream()
                .filter(r -> r.score() >= 0)
                .mapToDouble(QuestionResult::score)
                .average()
                .orElse(0.0);
    }

    private String buildContext(String examType, String sectionName) {
        return String.format("Exam: %s, Section: %s", examType, sectionName);
    }

    private List<QuestionResult> mergeResults(List<QuestionResult> mc, List<QuestionResult> open) {
        var merged = new ArrayList<>(mc);
        merged.addAll(open);
        return merged;
    }

    private String normalize(String s) {
        return s == null ? "" : s.trim();
    }

    /**
     * Extracts the leading answer letter from an option string.
     *
     * Handles the mismatch between how the frontend stores the full selected
     * option text ("D) The opportunity cost...") and how the DB stores the
     * correct answer as a bare letter ("D").
     *
     * Examples:
     *   "D) The opportunity cost is constant" → "D"
     *   "A) 1: normative, 2: normative"       → "A"
     *   "D"                                   → "D"
     *   "d."                                  → "D"
     */
    private String extractLetter(String response) {
        if (response == null || response.isBlank()) return "";
        String trimmed = response.trim();
        java.util.regex.Matcher m =
                java.util.regex.Pattern.compile("^([A-Da-d])[).\\s]")
                        .matcher(trimmed);
        return m.find() ? m.group(1).toUpperCase() : trimmed.trim().toUpperCase();
    }
}