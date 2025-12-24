package com.edusupernova.edusupernova.data;
import com.edusupernova.edusupernova.model.Unit;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UnitRepository extends JpaRepository<Unit, Integer> {

    // 1. Obtener todas las unidades de un exam ordenadas por queue
    List<Unit> findByExamIdOrderByQueueAsc(Integer examId);

    // 2. Obtener una unidad por ID (con su Exam cargado automáticamente)
    @Override
    Optional<Unit> findById(Integer id);

    // Opcional: si quieres asegurarte de que el Exam se cargue ansiosamente
    // @EntityGraph(attributePaths = {"exam"})
    // Optional<Unit> findWithExamById(Integer id);
}