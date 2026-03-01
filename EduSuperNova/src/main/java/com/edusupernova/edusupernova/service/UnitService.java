package com.edusupernova.edusupernova.service;

import com.edusupernova.edusupernova.data.CourseRepository;
import com.edusupernova.edusupernova.data.UnitRepository;
import com.edusupernova.edusupernova.model.Courses;
import com.edusupernova.edusupernova.model.Unit;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.File;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Collections;
import java.util.List;

@Service
@RequiredArgsConstructor
public class UnitService {

    @Autowired
    private UnitRepository unitRepo;

    /**
     * Obtiene todas las unidades de un curso específico, ordenadas por queue
     * Este es el método principal que usa el CourseService para mostrar las unidades
     */
    public List<Unit> getUnitsByCourseId(Integer courseId) {
        List<Unit> units = unitRepo.findByCourseIdOrderByQueueAsc(courseId);
        String rootPath = System.getProperty("user.dir");

        for (Unit unit : units) {
            try {
                // 1. Limpiamos cualquier barra invertida que venga de la DB
                String rawPath = unit.getSummary_path().trim();
                String[] parts = rawPath.replace("\\", "/").split("/");

                // 2. Construimos la ruta base
                Path fullPath = Paths.get(rootPath, "EduSuperNova");

                // 3. Añadimos cada pieza individualmente.
                // Esto obliga a Windows a poner la "\" correctamente.
                for (String part : parts) {
                    if (!part.isEmpty()) {
                        fullPath = fullPath.resolve(part);
                    }
                }

                System.out.println("INTENTO DE CARGA: " + fullPath.toAbsolutePath());

                if (Files.exists(fullPath)) {
                    unit.setSummary_path(Files.readString(fullPath, StandardCharsets.UTF_8));
                } else {
                    unit.setSummary_path("ERROR: Archivo no encontrado en: " + fullPath.toAbsolutePath());
                }
            } catch (IOException e) {
                unit.setSummary_path("ERROR: Fallo crítico al leer el archivo.");
            }
        }
        return units;
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

