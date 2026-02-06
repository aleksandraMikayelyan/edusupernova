package com.edusupernova.edusupernova.data;



import com.edusupernova.edusupernova.model.Exams;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ExamRepository extends JpaRepository<Exams, Integer> {

    // 1. Todos los exámenes activos, ordenados por nombre (ideal para dashboard)
    List<Exams> findAllByIsActiveTrueOrderByExamnameAsc();

    // 2. Versión con paginación (muy recomendada si puedes tener +50 exámenes)
    Page<Exams> findAllByIsActiveTrueOrderByExamnameAsc(Pageable pageable);

    /*// 3. Búsqueda avanzada corregida + filtro por activo + orden prioritario
    @Query("""
        SELECT e
        FROM Exams e
        WHERE e.isActive = true
          AND (LOWER(e.examname) LIKE LOWER(CONCAT('%', :term, '%'))
               OR LOWER(e.description) LIKE LOWER(CONCAT('%', :term, '%')))
        ORDER BY
            CASE
                WHEN LOWER(e.examname) LIKE LOWER(CONCAT(:term, '%')) THEN 1
                WHEN LOWER(e.examname) LIKE LOWER(CONCAT('%', :term, '%')) THEN 2
                ELSE 3
            END,
            e.examname
        """)
    List<Exams> searchActiveByNameOrDescription(@Param("term") String term);

    // 4. Versión paginada de la búsqueda (muy útil en frontend)
    @Query("""
        SELECT e
        FROM Exams e
        WHERE e.isActive = true
          AND (LOWER(e.examname) LIKE LOWER(CONCAT('%', :term, '%'))
               OR LOWER(e.description) LIKE LOWER(CONCAT('%', :term, '%')))
        ORDER BY
            CASE
                WHEN LOWER(e.examname) LIKE LOWER(CONCAT(:term, '%')) THEN 1
                WHEN LOWER(e.examname) LIKE LOWER(CONCAT('%', :term, '%')) THEN 2
                ELSE 3
            END,
            e.examname
        """)
    Page<Exams> searchActiveByNameOrDescriptionPaginated(@Param("term") String term, Pageable pageable);*/

    // Versión paginada
    Page<Exams> findByIsActiveTrueAndExamnameContainingIgnoreCaseOrIsActiveTrueAndDescriptionContainingIgnoreCase(String nameTerm);
    // 5. Alternativa más simple (si no necesitas el orden prioritario)
    List<Exams> findByIsActiveTrueAndExamNameContainingIgnoreCaseOrDescriptionContainingIgnoreCaseOrderByExamnameAsc(
            String examname, String description);

    // 6. Bonus: contar exámenes activos (útil para dashboard)
    long countByIsActiveTrue();
}