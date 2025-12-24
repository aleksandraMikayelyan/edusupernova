package com.edusupernova.edusupernova.data;



import com.edusupernova.edusupernova.model.Exams;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ExamRepository extends JpaRepository<Exams, Integer> {

    // dashboard(): Todos los exams ordenados por nombre
    List<Exams> findAllByOrderByNameAsc();

    // findById(): Ya lo tienes gratis con JpaRepository
    // Optional<Exam> findById(Integer id);  // ← heredado

    // Búsqueda avanzada (equivalente a tu search con LIKE y orden prioritario)
    @Query("""
            SELECT e
            FROM Exams e
            WHERE LOWER(e.name) LIKE LOWER(CONCAT('%', :term, '%'))
               OR LOWER(e.description) LIKE LOWER(CONCAT('%', :term, '%'))
            ORDER BY
                CASE
                    WHEN LOWER(e.name) LIKE LOWER(CONCAT(:term, '%')) THEN 1
                    WHEN LOWER(e.name) LIKE LOWER(CONCAT('%', :term, '%')) THEN 2
                    ELSE 3
                END,
                e.name
        """)
    List<Exams> searchByNameOrDescription(@Param("term") String term);

    // Versión más simple si no necesitas el orden tan sofisticado
    // List<Exam> findByNameContainingIgnoreCaseOrDescriptionContainingIgnoreCase(String name, String description);
}