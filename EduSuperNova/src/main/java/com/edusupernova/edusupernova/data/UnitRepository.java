package com.edusupernova.edusupernova.data;
import com.edusupernova.edusupernova.model.Unit;

import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UnitRepository extends JpaRepository<Unit, Integer> {

    // Unidades de un curso específico, ordenadas por queue
    List<Unit> findByCourseIdOrderByQueueAsc(Integer courseId);

    // Si todavía lo necesitas: unidades de un examen (pasando por el curso)
    @Query("SELECT u FROM Unit u WHERE u.course.exam.idExam = :examId ORDER BY u.queue ASC")
    List<Unit> findByExamIdOrderByQueueAsc(@Param("examId") Integer examId);

    // Opcional: si quieres cargar el course/exam al buscar por ID
    @EntityGraph(attributePaths = {"course", "course.exam"})
    Optional<Unit> findById(Integer id);
}