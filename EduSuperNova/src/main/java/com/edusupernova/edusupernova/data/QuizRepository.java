package com.edusupernova.edusupernova.data;

import com.edusupernova.edusupernova.model.Quiz;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * FIX: All 'type' parameters changed from String → Quiz.QuestionType.
 * Hibernate 6 validates parameter types strictly against the mapped entity
 * field. Passing a String where the field is a Quiz.QuestionType enum causes:
 *   QueryArgumentException: Argument did not match parameter type
 */
@Repository
public interface QuizRepository extends JpaRepository<Quiz, Integer> {

    List<Quiz> findByCourseIdAndType(Integer courseId, Quiz.QuestionType type);

    List<Quiz> findByCourseId(Integer courseId);

    List<Quiz> findByCourseIdAndTypeIn(Integer courseId, List<Quiz.QuestionType> types);

    long countByCourseIdAndType(Integer courseId, Quiz.QuestionType type);

    long countByCourseId(Integer courseId);
}