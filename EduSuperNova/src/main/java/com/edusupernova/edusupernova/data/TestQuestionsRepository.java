package com.edusupernova.edusupernova.data;

import com.edusupernova.edusupernova.model.QuestionGroup;
import com.edusupernova.edusupernova.model.TestQuestionId;
import com.edusupernova.edusupernova.model.TestQuestions;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TestQuestionsRepository extends JpaRepository<TestQuestions, TestQuestionId> {

    // Borrar todas las respuestas de un test
    void deleteByTestId(Integer testId);

    // Conteo rápido: cuántas correctas
    long countByTestIdAndCorrectResponseTrue(Integer testId);

    // Conteo total de respuestas
    long countByTestId(Integer testId);

    // JOIN FETCH quiz to avoid lazy loading outside transaction (prevents Session closed errors)
    @Query("SELECT tq FROM TestQuestions tq JOIN FETCH tq.quiz WHERE tq.id.testId = :testId")
    List<TestQuestions> findByIdTestId(@Param("testId") Integer testId);

    @Query("SELECT tq FROM TestQuestions tq JOIN FETCH tq.quiz WHERE tq.id.testId = :testId ORDER BY tq.id.quizId ASC")
    List<TestQuestions> findByIdTestIdOrderByIdQuizIdAsc(@Param("testId") Integer testId);

    /**
     * Batch-fetches (testId, quizId) pairs for multiple tests in a single query.
     * Used by getHistory() to build the quiz-set fingerprint for deduplication without N+1 queries.
     */
    @Query("SELECT tq.id.testId, tq.id.quizId FROM TestQuestions tq WHERE tq.id.testId IN :testIds")
    List<Object[]> findQuizIdsByTestIds(@Param("testIds") List<Integer> testIds);
    boolean existsByIdTestIdAndIdQuizId(Integer testId, Integer quizId);

    java.util.Optional<TestQuestions> findByIdTestIdAndIdQuizId(Integer testId, Integer quizId);

    /**
     * Returns the IDs of QuestionGroups the user has already completed for a
     * specific paper. Used by startTest() to exclude done extracts/passages from
     * the next test generation.
     */
    @Query("""
        SELECT DISTINCT tq.quiz.questionGroup.id
        FROM TestQuestions tq
        WHERE tq.test.user.id   = :userId
        AND   tq.test.status    = 'COMPLETED'
        AND   tq.test.paper.id  = :paperId
        AND   tq.quiz.questionGroup IS NOT NULL
        """)
    List<Integer> findCompletedGroupIdsByUserAndPaper(
            @Param("userId")  Integer userId,
            @Param("paperId") Integer paperId);

    /**
     * Returns all QuestionGroups the user has ever completed (any paper).
     * Used by GET /api/progress/completed-groups for the profile view.
     */
    @Query("""
        SELECT DISTINCT tq.quiz.questionGroup
        FROM TestQuestions tq
        WHERE tq.test.user.id = :userId
        AND   tq.test.status  = 'COMPLETED'
        AND   tq.quiz.questionGroup IS NOT NULL
        """)
    List<QuestionGroup> findCompletedGroupsByUser(@Param("userId") Integer userId);
}