package com.edusupernova.edusupernova.data;

import com.edusupernova.edusupernova.model.TestQuestionId;
import com.edusupernova.edusupernova.model.TestQuestions;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TestQuestionsRepository extends JpaRepository<TestQuestions, TestQuestionId> {

    // Guardar batch de respuestas
    @Override
    <S extends TestQuestions> List<S> saveAll(Iterable<S> entities);

    // Borrar todas las respuestas de un test
    void deleteByTestId(Integer testId);

    // Conteo rápido: cuántas correctas
    long countByTestIdAndCorrectResponseTrue(Integer testId);

    // Conteo total de respuestas
    long countByTestId(Integer testId);

    List<TestQuestions> findByIdTestId(Integer testId);
    List<TestQuestions> findByIdTestIdOrderByIdQuizIdAsc(Integer testId);
    boolean existsByIdTestIdAndIdQuizId(Integer testId, Integer quizId);

    java.util.Optional<TestQuestions> findByIdTestIdAndIdQuizId(Integer testId, Integer quizId);
}