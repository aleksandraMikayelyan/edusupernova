package com.edusupernova.edusupernova.data;

import com.edusupernova.edusupernova.model.TestQuestions;
import com.edusupernova.edusupernova.model.Tests;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TestRepository extends JpaRepository<Tests, Integer> {

    // Crear test vacío: save() devuelve la entidad con ID generado automáticamente
    @Override
    <S extends Tests> S save(S entity);

    // Buscar tests de un usuario y exam (opcional, útil para listados)
    List<Tests> findByUserIdAndExamId(Integer userId, Integer examId);
}

