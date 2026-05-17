package com.edusupernova.edusupernova.data;

import com.edusupernova.edusupernova.model.Quiz;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * FIX: All 'type' parameters changed from String → Quiz.QuestionType.
 * FIX: Method names corrected from ...AndType... → ...AndQuestionType...
 *      to match the actual field name on the Quiz entity.
 * ADDED: findByPaperId / findByPaperIdAndUnitId for paper-based test generation.
 * ADDED: countByCourseIdAndQuestionTypeIn for canGenerateTest stats.
 */
@Repository
public interface QuizRepository extends JpaRepository<Quiz, Integer> {

    // ── Course-based queries (used by legacy QuestionsController) ─────────────

    List<Quiz> findByCourseId(Integer courseId);

    List<Quiz> findByCourseIdAndQuestionType(Integer courseId, Quiz.QuestionType questionType);

    List<Quiz> findByCourseIdAndQuestionTypeIn(Integer courseId, List<Quiz.QuestionType> questionTypes);

    long countByCourseId(Integer courseId);

    long countByCourseIdAndQuestionType(Integer courseId, Quiz.QuestionType questionType);

    long countByCourseIdAndQuestionTypeIn(Integer courseId, List<Quiz.QuestionType> questionTypes);

    // ── Paper-based queries (used by TestSessionService via QuizService) ────────

    /** All questions for a paper, regardless of unit. */
    List<Quiz> findByPaperId(Integer paperId);

    /** Questions for a paper filtered to a specific unit. */
    List<Quiz> findByPaperIdAndUnitId(Integer paperId, Integer unitId);

    /** All questions belonging to a specific QuestionGroup (for "practice again"). */
    List<Quiz> findByQuestionGroupId(Integer groupId);
}
