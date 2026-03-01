package com.edusupernova.edusupernova.data;
import com.edusupernova.edusupernova.model.Courses;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface CourseRepository extends JpaRepository<Courses, Integer> {

    // Método clave: carga el curso + sus unidades en una sola consulta
    @EntityGraph(attributePaths = {"units"})  // ← carga automáticamente la lista de unidades
    Optional<Courses> findById(Integer id);

    List<Courses> findByExamId(Integer examId);

    //long countByExamId(Integer examId);
}
