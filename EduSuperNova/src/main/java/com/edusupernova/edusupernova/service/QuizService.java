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
 * Handles all quiz-related business logic:
 * fetching, filtering, and assembling randomized test question sets.
 *
 * SRP  – only responsible for quiz data and test composition logic.
 * OCP  – new question types can be added without modifying this class.
 * DIP  – depends on the QuizRepository abstraction, not a concrete impl.
 */
@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class QuizService {

    // ── Constants ────────────────────────────────────────────────────────────

    private static final int MULTIPLE_CHOICE_LIMIT = 15;
    private static final int OPEN_ENDED_LIMIT       = 5;

    private static final Quiz.QuestionType TYPE_MULTIPLE_CHOICE  = Quiz.QuestionType.MULTIPLE_CHOICE;
    private static final Quiz.QuestionType TYPE_OPEN_ENDED       = Quiz.QuestionType.OPEN_ENDED;
    private static final Quiz.QuestionType TYPE_LOGICAL_PROBLEMS = Quiz.QuestionType.LOGICAL_PROBLEMS;

    // ── Dependencies ─────────────────────────────────────────────────────────

    private final QuizRepository quizRepository;

    // ── Public API ───────────────────────────────────────────────────────────

    /**
     * Builds a randomized test for the given course:
     *   • 15 randomly selected Multiple Choice questions
     *   •  5 randomly selected Open Ended / Logical Problems questions
     *
     * Called by {@link TestService} when the user clicks "Check my knowledge".
     *
     * @param courseId the course to draw questions from
     * @return shuffled list of 20 questions (or fewer if the bank is small)
     */
    public List<Quiz> generateRandomTest(int courseId) {
        List<Quiz> multipleChoiceQuestions = pickRandom(
                quizRepository.findByCourseIdAndType(courseId, TYPE_MULTIPLE_CHOICE),
                MULTIPLE_CHOICE_LIMIT
        );

        List<Quiz> openEndedQuestions = pickRandom(
                quizRepository.findByCourseIdAndTypeIn(
                        courseId, List.of(TYPE_OPEN_ENDED, TYPE_LOGICAL_PROBLEMS)),
                OPEN_ENDED_LIMIT
        );

        List<Quiz> finalTest = new ArrayList<>(multipleChoiceQuestions.size() + openEndedQuestions.size());
        finalTest.addAll(multipleChoiceQuestions);
        finalTest.addAll(openEndedQuestions);
        Collections.shuffle(finalTest);

        log.debug("Generated test for courseId={}: {} MC + {} open-ended = {} total",
                courseId,
                multipleChoiceQuestions.size(),
                openEndedQuestions.size(),
                finalTest.size());

        return finalTest;
    }

    /**
     * Returns true when the course question bank has enough questions
     * to generate a full test ({@value #MULTIPLE_CHOICE_LIMIT} MC
     * and {@value #OPEN_ENDED_LIMIT} open-ended / logical).
     */
    public boolean canGenerateTest(int courseId) {
        long mcCount   = quizRepository.countByCourseIdAndType(courseId, TYPE_MULTIPLE_CHOICE);
        long openCount = quizRepository.countByCourseIdAndType(courseId, TYPE_OPEN_ENDED)
                + quizRepository.countByCourseIdAndType(courseId, TYPE_LOGICAL_PROBLEMS);

        return mcCount >= MULTIPLE_CHOICE_LIMIT && openCount >= OPEN_ENDED_LIMIT;
    }

    /** Returns a human-readable summary of available questions for a course. */
    public String getQuestionStats(int courseId) {
        long total   = quizRepository.countByCourseId(courseId);
        long mc      = quizRepository.countByCourseIdAndType(courseId, TYPE_MULTIPLE_CHOICE);
        long openEnd = quizRepository.countByCourseIdAndType(courseId, TYPE_OPEN_ENDED);
        long logical = quizRepository.countByCourseIdAndType(courseId, TYPE_LOGICAL_PROBLEMS);

        return String.format(
                "Available questions — Total: %d | Multiple Choice: %d | Open Ended: %d | Logical: %d",
                total, mc, openEnd, logical);
    }

    /** Returns the count of questions of a given type for a course. */
    public int countByType(int courseId, Quiz.QuestionType type) {
        return (int) quizRepository.countByCourseIdAndType(courseId, type);
    }

    // ── Private helpers ──────────────────────────────────────────────────────

    /**
     * Shuffles {@code source} in-place and returns the first {@code limit}
     * elements. If the list is smaller than {@code limit} all elements are
     * returned (no exception thrown — caller decides if that's acceptable).
     */
    private <T> List<T> pickRandom(List<T> source, int limit) {
        Collections.shuffle(source);
        return source.stream().limit(limit).toList();
    }
}