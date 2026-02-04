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

    // Guardar batch de respuestas (ya lo hereda, pero está bien documentarlo)
    @Override
    <S extends TestQuestions> List<S> saveAll(Iterable<S> entities);

    // Borrar todas las respuestas de un test específico
    void deleteByTestId(Integer testId);

    // Obtener todas las respuestas de un test
    //List<TestQuestions> findByTestId(Integer testId);

    // Versión con orden (útil si quieres mostrar en el orden que se presentaron)
    List<TestQuestions> findByTestIdOrderByQuizIdAsc(Integer testId);

    // Conteo rápido: cuántas correctas tiene el test
    long countByTestIdAndCorrectResponseTrue(Integer testId);

    // Conteo total de respuestas en el test (debería ser = número de preguntas)
    long countByTestId(Integer testId);

    // Verificar si YA existe una respuesta para esa pregunta en ese test
    // (evita duplicados si el usuario envía dos veces la misma pregunta)
    boolean existsByIdTestIdAndIdQuizId(Integer testId, Integer quizId);

    // Opcional: traer respuestas con la pregunta (quiz) cargada
    // (evita N+1 si vas a mostrar texto de pregunta, opciones, etc.)
    @EntityGraph(attributePaths = {"quiz"})
    List<TestQuestions> findByTestId(Integer testId);

    // Alternativa con query si prefieres control total
    @Query("SELECT tq FROM TestQuestions tq JOIN FETCH tq.quiz WHERE tq.id.idTest = :testId")
    List<TestQuestions> findByTestIdWithQuiz(@Param("testId") Integer testId);
}