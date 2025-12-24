package com.edusupernova.edusupernova.data;

import com.edusupernova.edusupernova.model.TestQuestionId;
import com.edusupernova.edusupernova.model.TestQuestions;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TestQuestionsRepository extends JpaRepository<TestQuestions, TestQuestionId> {

        // Guardar todas las respuestas: saveAll() hace batch insert/update automáticamente
        @Override
        <S extends TestQuestions> List<S> saveAll(Iterable<S> entities);

        // Opcional: borrar todas las respuestas de un test
        void deleteByTestId(Integer testId);

        // Opcional: obtener respuestas de un test
        List<TestQuestions> findByTestId(Integer testId);
}

