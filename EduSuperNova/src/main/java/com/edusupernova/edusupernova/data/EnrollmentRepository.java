package com.edusupernova.edusupernova.data;

import com.edusupernova.edusupernova.model.Enrollment;
import com.edusupernova.edusupernova.model.EnrollmentId;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;


import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository
public interface EnrollmentRepository extends JpaRepository<Enrollment, EnrollmentId> {

    // Comprobar si ya está inscrito (equivalente a isEnrolled)
    boolean existsByUserIdAndExamId(Integer userId, Integer examId);

    // Inscribir usuario en un exam (INSERT IGNORE → save hace upsert si existe PK)
    // Como la PK es compuesta, save() no inserta duplicados → actúa como INSERT IGNORE
    @Override
    <S extends Enrollment> S save(S entity);

    // Desinscribir
    void deleteByUserIdAndExamId(Integer userId, Integer examId);

    // Obtener todos los exams inscritos por un usuario
    List<Enrollment> findByUserId(Integer userId);
}
