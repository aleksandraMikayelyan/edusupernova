package com.edusupernova.edusupernova.data;

import com.edusupernova.edusupernova.model.Quiz;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface QuizRepository extends JpaRepository<Quiz, Integer> {

    // Contar preguntas por tipo en un curso específico
    long countByCourseIdAndType(Integer courseId, String type);

    // Generar test aleatorio para un curso concreto
    @Query(value = """
        SELECT * FROM (
            (SELECT * FROM Quizes
             WHERE idCourse = :courseId
             AND type = 'multipleChoice'
             ORDER BY RAND() LIMIT 15)
            UNION ALL
            (SELECT * FROM Quizes
             WHERE idCourse = :courseId
             AND type IN ('openEnded', 'logicalProblems')
             ORDER BY RAND() LIMIT 5)
        ) AS selected_questions
        """, nativeQuery = true)
    List<Quiz> generateRandomTest(@Param("courseId") Integer courseId);

    // Opcional: contar total de preguntas en un curso
    long countByCourseId(Integer courseId);
}

