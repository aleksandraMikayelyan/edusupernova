package com.edusupernova.edusupernova.test.service;

import com.edusupernova.edusupernova.data.QuizRepository;
import com.edusupernova.edusupernova.model.Paper;
import com.edusupernova.edusupernova.model.Quiz;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * Provides question selection and test-generation logic.
 *
 * Two generation modes:
 *   1. generateRandomTest(courseId)          — legacy "quick test": 15 MCQ + 5 open-ended
 *   2. generateTestForPaper(paperId, unitId) — paper-aware, used by TestSessionService.startTest()
 *
 * canGenerateTest / getQuestionStats are guards called by QuestionsController before
 * attempting generation to surface helpful errors to the admin.
 */
@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class QuizService {

    private static final int MCQ_COUNT  = 15;
    private static final int OPEN_COUNT = 5;

    private static final List<Quiz.QuestionType> MCQ_TYPES = List.of(
            Quiz.QuestionType.MULTIPLE_CHOICE,
            Quiz.QuestionType.TRUE_FALSE_NG,
            Quiz.QuestionType.NUMERIC_INPUT
    );

    private static final List<Quiz.QuestionType> OPEN_TYPES = List.of(
            Quiz.QuestionType.SHORT_ANSWER,
            Quiz.QuestionType.ESSAY,
            Quiz.QuestionType.OPEN_ENDED
    );

    private final QuizRepository quizRepository;

    // ── Called by QuestionsController ─────────────────────────────────────────

    /**
     * Returns true if the course has at least 15 MCQ-type and 5 open-ended questions.
     */
    public boolean canGenerateTest(int courseId) {
        long mcq  = quizRepository.countByCourseIdAndQuestionTypeIn(courseId, MCQ_TYPES);
        long open = quizRepository.countByCourseIdAndQuestionTypeIn(courseId, OPEN_TYPES);
        return mcq >= MCQ_COUNT && open >= OPEN_COUNT;
    }

    /**
     * Human-readable summary of available questions for a course.
     */
    public String getQuestionStats(int courseId) {
        long mcq   = quizRepository.countByCourseIdAndQuestionTypeIn(courseId, MCQ_TYPES);
        long open  = quizRepository.countByCourseIdAndQuestionTypeIn(courseId, OPEN_TYPES);
        long total = quizRepository.countByCourseId(courseId);
        return String.format(
                "Course %d: %d total — %d MCQ/TF/Numeric (need %d), %d open-ended (need %d)",
                courseId, total, mcq, MCQ_COUNT, open, OPEN_COUNT
        );
    }

    /**
     * Generates a randomised test for a course: 15 MCQ-type + 5 open-ended.
     * Used by the legacy GET /api/questions/generate/{courseId} endpoint.
     */
    public List<Quiz> generateRandomTest(int courseId) {
        List<Quiz> mcqs = shuffled(quizRepository.findByCourseIdAndQuestionTypeIn(courseId, MCQ_TYPES));
        List<Quiz> open = shuffled(quizRepository.findByCourseIdAndQuestionTypeIn(courseId, OPEN_TYPES));

        List<Quiz> result = new ArrayList<>();
        result.addAll(mcqs.subList(0, Math.min(MCQ_COUNT, mcqs.size())));
        result.addAll(open.subList(0, Math.min(OPEN_COUNT, open.size())));
        Collections.shuffle(result);

        log.debug("generateRandomTest courseId={} → {} questions", courseId, result.size());
        return result;
    }

    // ── Called by TestSessionService ─────────────────────────────────────────

    /**
     * Picks a randomised question set for a specific Paper, optionally filtered
     * to a single Unit. Total count is driven by Paper.totalQuestions.
     *
     * Fallback: if no questions are linked to this paper (idPaper = NULL in DB),
     * the method falls back to a course-level query filtered by question type —
     * MCQ types for MCQ/numeric papers, open-ended types for essay papers.
     *
     * @param paper          paper entity (carries format, courseId, totalQuestions)
     * @param unitId         optional unit filter; null = all units in the paper
     * @param totalQuestions how many questions to return; if pool is smaller, returns all
     */
    /**
     * @param excludeGroupIds QuestionGroup IDs the user has already completed for
     *                        this paper — they are skipped so the student always
     *                        gets fresh extracts/passages. If all groups have been
     *                        done the exclusion resets automatically (all groups
     *                        become eligible again).
     */
    public List<Quiz> generateTestForPaper(
            Paper paper, Integer unitId, Integer totalQuestions,
            Set<Integer> excludeGroupIds) {
        Integer paperId  = paper.getId();
        Integer courseId = paper.getCourse().getId();

        // Primary: questions explicitly linked to this paper
        List<Quiz> pool = (unitId != null)
                ? quizRepository.findByPaperIdAndUnitId(paperId, unitId)
                : quizRepository.findByPaperId(paperId);

        // Fallback 1: questions have idPaper = NULL → select by course + question type
        if (pool.isEmpty()) {
            log.warn("No questions linked to paperId={} — trying course {} + type fallback",
                    paperId, courseId);
            List<Quiz.QuestionType> types = isEssayFormat(paper.getFormat())
                    ? OPEN_TYPES
                    : MCQ_TYPES;
            pool = (unitId != null)
                    ? quizRepository.findByCourseIdAndQuestionTypeIn(courseId, types)
                            .stream()
                            .filter(q -> q.getUnit() != null && q.getUnit().getId().equals(unitId))
                            .toList()
                    : quizRepository.findByCourseIdAndQuestionTypeIn(courseId, types);
        }

        // Fallback 2: no questions of the expected type → use ANY questions for this course
        if (pool.isEmpty()) {
            log.warn("No type-matched questions for course {} — using all course questions as last resort",
                    courseId);
            pool = (unitId != null)
                    ? quizRepository.findByCourseId(courseId)
                            .stream()
                            .filter(q -> q.getUnit() != null && q.getUnit().getId().equals(unitId))
                            .toList()
                    : quizRepository.findByCourseId(courseId);
        }

        log.debug("generateTestForPaper paperId={} unitId={} pool={} format={}",
                paperId, unitId, pool.size(), paper.getFormat());

        // READING_WRITING (Cambridge AS English Paper 1): exactly 1 Text A group + 1 Text B group
        if (paper.getFormat() == Paper.PaperFormat.READING_WRITING) {
            List<Quiz> selected = selectReadingWritingGroups(pool, excludeGroupIds);
            log.debug("generateTestForPaper (reading_writing) selected={} excludedGroups={}",
                    selected.size(), excludeGroupIds.size());
            return selected;
        }

        // Grouped formats: pick whole QuestionGroups so extracts/passages stay intact
        if (isGroupedFormat(paper.getFormat())) {
            List<Quiz> selected = selectByGroup(pool, totalQuestions, excludeGroupIds);
            log.debug("generateTestForPaper (grouped) selected={} excludedGroups={}",
                    selected.size(), excludeGroupIds.size());
            return selected;
        }

        // Non-grouped formats: original random selection
        List<Quiz> shuffledPool = shuffled(pool);
        int count = (totalQuestions != null && totalQuestions < shuffledPool.size())
                ? totalQuestions
                : shuffledPool.size();
        return new ArrayList<>(shuffledPool.subList(0, count));
    }

    /**
     * For DATA_RESPONSE / READING / MULTI_ESSAY / LISTENING papers, questions
     * belong to QuestionGroups (extracts/passages). Selecting individual questions
     * at random would orphan sub-questions from their extract context.
     *
     * This method shuffles the GROUPS and picks whole groups until totalQuestions
     * is reached. Sub-questions within each group keep their groupOrderIndex order
     * (a, b, c, d, e). If a question has no group it is treated as a group of one.
     */
    private List<Quiz> selectByGroup(List<Quiz> pool, Integer totalQuestions,
                                     Set<Integer> excludeGroupIds) {
        // Bucket questions by group id (preserves insertion order for stable output)
        Map<Integer, List<Quiz>> byGroup = new LinkedHashMap<>();
        List<Quiz> ungrouped = new ArrayList<>();

        for (Quiz q : pool) {
            if (q.getQuestionGroup() != null) {
                byGroup.computeIfAbsent(q.getQuestionGroup().getId(), k -> new ArrayList<>())
                       .add(q);
            } else {
                ungrouped.add(q);
            }
        }

        // Sort sub-questions within each group by their display order (a→b→c…)
        byGroup.values().forEach(group -> group.sort(
                Comparator.comparingInt(q -> q.getGroupOrderIndex() != null ? q.getGroupOrderIndex() : 0)
        ));

        // Filter out groups the user has already completed for this paper
        List<List<Quiz>> freshGroups = byGroup.entrySet().stream()
                .filter(e -> !excludeGroupIds.contains(e.getKey()))
                .map(Map.Entry::getValue)
                .collect(java.util.stream.Collectors.toCollection(ArrayList::new));

        // Auto-reset: if the student has done every group, let all groups back in
        if (freshGroups.isEmpty() && !byGroup.isEmpty()) {
            log.info("All QuestionGroups for this paper have been completed — resetting exclusion list");
            freshGroups = new ArrayList<>(byGroup.values());
        }

        // Shuffle the groups themselves so each test gets a different extract combination
        Collections.shuffle(freshGroups);

        int target = (totalQuestions != null) ? totalQuestions : Integer.MAX_VALUE;
        List<Quiz> result = new ArrayList<>();

        // Add whole groups — never split a group mid-way
        for (List<Quiz> group : freshGroups) {
            if (result.size() >= target) break;
            result.addAll(group);
        }

        // Top up with ungrouped questions if the pool was short
        if (result.size() < target && !ungrouped.isEmpty()) {
            Collections.shuffle(ungrouped);
            int need = target - result.size();
            result.addAll(ungrouped.subList(0, Math.min(need, ungrouped.size())));
        }

        return result;
    }

    /**
     * Cambridge AS English Language Paper 1 (READING_WRITING format).
     *
     * Text A groups have 2 questions: Q1(a) directed writing + Q1(b) compare own response.
     * Text B groups have 1 question:  Q2 text analysis.
     *
     * Identification is by question count (avoids lazy-loading the QuestionGroup entity):
     *   size >= 2  →  Text A
     *   size == 1  →  Text B
     *
     * If the DB has not yet been split into Text A / Text B (all groups still have 2 questions),
     * we fall back to picking 2 separate Text A groups so the student always gets 2 passages.
     */
    private List<Quiz> selectReadingWritingGroups(List<Quiz> pool, Set<Integer> excludeGroupIds) {
        Map<Integer, List<Quiz>> byGroup = new LinkedHashMap<>();
        for (Quiz q : pool) {
            if (q.getQuestionGroup() != null) {
                byGroup.computeIfAbsent(q.getQuestionGroup().getId(), k -> new ArrayList<>()).add(q);
            }
        }
        byGroup.values().forEach(g -> g.sort(
                Comparator.comparingInt(q -> q.getGroupOrderIndex() != null ? q.getGroupOrderIndex() : 0)));

        List<List<Quiz>> textA = byGroup.entrySet().stream()
                .filter(e -> !excludeGroupIds.contains(e.getKey()))
                .filter(e -> e.getValue().size() >= 2)
                .map(Map.Entry::getValue)
                .collect(java.util.stream.Collectors.toCollection(ArrayList::new));

        List<List<Quiz>> textB = byGroup.entrySet().stream()
                .filter(e -> !excludeGroupIds.contains(e.getKey()))
                .filter(e -> e.getValue().size() == 1)
                .map(Map.Entry::getValue)
                .collect(java.util.stream.Collectors.toCollection(ArrayList::new));

        // Auto-reset each bucket independently when exhausted
        if (textA.isEmpty()) {
            log.info("All Text A groups completed for this paper — resetting Text A exclusions");
            textA = byGroup.values().stream()
                    .filter(g -> g.size() >= 2)
                    .collect(java.util.stream.Collectors.toCollection(ArrayList::new));
        }
        if (textB.isEmpty()) {
            log.info("All Text B groups completed for this paper — resetting Text B exclusions");
            textB = byGroup.values().stream()
                    .filter(g -> g.size() == 1)
                    .collect(java.util.stream.Collectors.toCollection(ArrayList::new));
        }

        Collections.shuffle(textA);
        Collections.shuffle(textB);

        List<Quiz> result = new ArrayList<>();
        if (!textA.isEmpty()) result.addAll(textA.get(0));

        if (!textB.isEmpty()) {
            // DB already split: proper Text A + Text B
            result.addAll(textB.get(0));
        } else if (textA.size() >= 2) {
            // DB not yet split: use a second Text A group as the passage for Q2
            result.addAll(textA.get(1));
        }

        return result;
    }

    /** Formats whose questions belong to QuestionGroups (extracts/passages). */
    private boolean isGroupedFormat(Paper.PaperFormat format) {
        return switch (format) {
            case DATA_RESPONSE, READING, MULTI_ESSAY, LISTENING, MCQ -> true;
            default -> false;
        };
    }

    private boolean isEssayFormat(Paper.PaperFormat format) {
        return switch (format) {
            case ESSAY, DATA_RESPONSE, SHORT_ANSWER, LISTENING, READING, SPEAKING,
                 READING_WRITING, MULTI_ESSAY -> true;
            default -> false;
        };
    }

    // ── Private ───────────────────────────────────────────────────────────────

    private <T> List<T> shuffled(List<T> source) {
        List<T> copy = new ArrayList<>(source);
        Collections.shuffle(copy);
        return copy;
    }
}
