package com.edusupernova.edusupernova.data;

import com.edusupernova.edusupernova.model.TestQuestions;
import com.edusupernova.edusupernova.model.Tests;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface TestRepository extends JpaRepository<Tests, Integer> {  // ← singular Test

    List<Tests> findByUserIdAndCourseId(Integer userId, Integer courseId);

    List<Tests> findByUserIdAndPaperIdAndStatus(Integer userId, Integer paperId, Tests.TestStatus status);

    // Opcional: tests recientes de un usuario
    List<Tests> findByUserIdOrderByCreationDateDesc(Integer userId);

    // Si necesitas join fetch para traer respuestas
    @EntityGraph(attributePaths = {"testQuestions"})
    Optional<Tests> findWithAnswersById(Integer id);
}

