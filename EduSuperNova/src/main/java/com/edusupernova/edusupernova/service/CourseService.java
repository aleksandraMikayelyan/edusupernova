package com.edusupernova.edusupernova.service;

import com.edusupernova.edusupernova.data.CourseRepository;
import com.edusupernova.edusupernova.model.Courses;

import com.edusupernova.edusupernova.model.Unit;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class CourseService {

    @Autowired
    private CourseRepository courseRepository;

    @Autowired
    private UnitService unitService;  // o UnitRepository directamente

    /**
     * Devuelve el curso completo con sus unidades cargadas
     * (asumiendo que el frontend necesita ver nombre, descripción, icono y lista de unidades)
     */
    @Transactional(readOnly = true)
    public Courses getCourseWithUnits(Integer courseId) {
        // Opción 1: usando @EntityGraph en el repository (recomendada)
        Courses course = courseRepository.findById(courseId)
                .orElseThrow(() -> new RuntimeException("Curso no encontrado: " + courseId));

        // Si no usas @EntityGraph, fuerza la carga de unidades aquí
        // Hibernate.initialize(course.getUnits());  // ← alternativa manual

        return course;
    }

    /**
     * Versión alternativa: solo devuelve la lista de unidades del curso
     * (muy útil si el frontend solo necesita ir a las unidades)
     */
    @Transactional(readOnly = true)
    public List<Unit> getUnitsOfCourse(Integer courseId) {
        // Validación ligera
        if (!courseRepository.existsById(courseId)) {
            throw new RuntimeException("Curso no encontrado: " + courseId);
        }

        // Aquí llamas al UnitService o al repository directamente
        return unitService.getUnitsByCourseId(courseId);
        // O si prefieres inyectar UnitRepository:
        // return unitRepository.findByCourseIdOrderByQueueAsc(courseId);
    }

    /**
     * Si necesitas solo la info básica del curso (sin unidades)
     */
    @Transactional(readOnly = true)
    public Courses getCourseBasicInfo(Integer courseId) {
        return courseRepository.findById(courseId)
                .orElseThrow(() -> new RuntimeException("Curso no encontrado"));
    }

    // O directamente devolver las unidades cuando el usuario quiere ver el contenido del curso
    public List<Unit> getUnitsForCourse(Integer courseId) {
        return unitService.getUnitsByCourseId(courseId);
    }
    @Transactional(readOnly = true)
    public List<Courses> getCoursesByExamId(Integer examId) {
        return courseRepository.findByExamId(examId);
    }

}
