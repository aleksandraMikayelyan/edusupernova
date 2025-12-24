package com.edusupernova.edusupernova.data;

import com.edusupernova.edusupernova.model.Quiz;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface QuizRepository extends JpaRepository<Quiz, Integer> {

    // Contar preguntas por tipo y exam (equivalente a contarPorTipo)
    long countByExamIdAndQuestionType(Integer examId, String questionType);

    // Generar test aleatorio: 15 multiple_choice + 5 open_ended o logical_problems
    @Query(value = """
        SELECT * FROM (
            (SELECT * FROM Quiz 
             WHERE exam_id = :examId AND question_type = 'multiple_choice' 
             ORDER BY RAND() LIMIT 15)
            UNION ALL
            (SELECT * FROM Quiz 
             WHERE exam_id = :examId AND question_type IN ('open_ended', 'logical_problems') 
             ORDER BY RAND() LIMIT 5)
        ) AS selected_questions
        """, nativeQuery = true)
    List<Quiz> generateRandomTest(@Param("examId") Integer examId);

    // Alternativa más "JPA-like" sin SQL nativo (usa RAND() de MySQL)
    // Pero la nativa es más limpia para este caso de UNION + LIMIT separados
}

