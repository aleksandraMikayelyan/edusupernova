package com.edusupernova.edusupernova.service;

import com.edusupernova.edusupernova.data.CourseRepository;
import com.edusupernova.edusupernova.data.UnitRepository;
import com.edusupernova.edusupernova.model.Courses;
import com.edusupernova.edusupernova.model.Unit;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collections;
import java.util.List;

@Service
@Transactional(readOnly = true)
public class UnitService {

    @Autowired
    private UnitRepository unitRepo;

    /**
     * Obtiene todas las unidades de un curso específico, ordenadas por queue
     * Este es el método principal que usa el CourseService para mostrar las unidades
     */
    public List<Unit> getUnitsByCourseId(Integer courseId) {
        if (courseId == null) {
            return Collections.emptyList();
        }
        return unitRepo.findByCourseIdOrderByQueueAsc(courseId);
    }

    /**
     * Obtiene todas las unidades de un examen completo
     * (útil si en algún momento quieres mostrar unidades cruzando todos los cursos del examen)
     */
    public List<Unit> getByExamId(int examId) {
        // Si ya tienes el método en el repo, úsalo
        return unitRepo.findByExamIdOrderByQueueAsc(examId);

        // Alternativa si no lo tienes en el repo (más explícita):
        // return unitRepo.findByCourseExamIdOrderByQueueAsc(examId);
    }

    /**
     * Obtiene una unidad concreta por su ID
     * Devuelve null si no existe (como en tu código original)
     */
    public Unit getById(int unitId) {
        return unitRepo.findById(unitId).orElse(null);
    }

    /**
     * Versión más segura: lanza excepción si no se encuentra la unidad
     * (útil en flujos donde la unidad es obligatoria)
     */
    public Unit getByIdOrThrow(int unitId) {
        return unitRepo.findById(unitId)
                .orElseThrow(() -> new RuntimeException("Unidad no encontrada: " + unitId));
    }
}

