package com.edusupernova.edusupernova.service;

import com.edusupernova.edusupernova.data.QuizRepository;
import com.edusupernova.edusupernova.model.Quiz;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * Provides question selection and test-generation logic.
 *
 * Two generation modes:
 *   1. generateRandomTest(courseId)          — legacy "quick test": 15 MCQ + 5 open-ended
 *   2. generateTestForPaper(paperId, unitId) — paper-aware, used by TestService.startTest()
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

    // ── Called by TestService ─────────────────────────────────────────────────

    /**
     * Picks a randomised question set for a specific Paper, optionally filtered
     * to a single Unit. Total count is driven by Paper.totalQuestions.
     *
     * @param paperId        paper whose pool to draw from
     * @param unitId         optional unit filter; null = all units in the paper
     * @param totalQuestions how many questions to return; if pool is smaller, returns all
     */
    public List<Quiz> generateTestForPaper(Integer paperId, Integer unitId, Integer totalQuestions) {
        List<Quiz> pool = (unitId != null)
                ? quizRepository.findByPaperIdAndUnitId(paperId, unitId)
                : quizRepository.findByPaperId(paperId);

        List<Quiz> shuffledPool = shuffled(pool);
        int count = (totalQuestions != null && totalQuestions < shuffledPool.size())
                ? totalQuestions
                : shuffledPool.size();

        log.debug("generateTestForPaper paperId={} unitId={} pool={} selected={}",
                paperId, unitId, pool.size(), count);
        return new ArrayList<>(shuffledPool.subList(0, count));
    }

    // ── Private ───────────────────────────────────────────────────────────────

    private <T> List<T> shuffled(List<T> source) {
        List<T> copy = new ArrayList<>(source);
        Collections.shuffle(copy);
        return copy;
    }
}
