package com.edusupernova.edusupernova.service;

import com.edusupernova.edusupernova.data.ExamRepository;
import com.edusupernova.edusupernova.model.Exams;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class ExamsService {

    @Autowired
    private ExamRepository examRepo;

    // Dashboard: solo exámenes activos, ordenados por nombre
    @Transactional(readOnly = true)
    public List<Exams> getDashboardExams() {
        return examRepo.findAllByIsActiveTrueOrderByExamnameAsc();
    }

    // Búsqueda con fallback a todos los activos si no hay término
    @Transactional(readOnly = true)
    public List<Exams> search(String searchTerm) {
        if (searchTerm == null || searchTerm.trim().isEmpty()) {
            return getDashboardExams(); // ← fallback útil
        }

        String term = searchTerm.trim();
        List<Exams> results = examRepo.searchActiveByNameOrDescription(term);

        // Límite suave a 20 (puedes quitarlo si usas paginación)
        return results.size() > 20 ? results.subList(0, 20) : results;
    }

    // Buscar un examen por ID
    @Transactional(readOnly = true)
    public Exams findById(Integer examId) {
        return examRepo.findById(examId).orElse(null);
    }

    // Crear nuevo examen con validaciones básicas
    @Transactional
    public Exams createExam(Exams exam) {
        if (exam == null) {
            throw new IllegalArgumentException("El examen no puede ser nulo");
        }
        if (exam.getExamname() == null || exam.getExamname().trim().isEmpty()) {
            throw new IllegalArgumentException("El nombre del examen es obligatorio");
        }
        if (exam.getExamname().length() > 100) {
            throw new IllegalArgumentException("El nombre no puede superar 100 caracteres");
        }

        // Opcional: verificar si ya existe uno con el mismo nombre
        // if (examRepo.existsByExamname(exam.getExamname())) { ... }

        exam.setIsActive(true); // por defecto activo al crear
        return examRepo.save(exam);
    }

    // Bonus: método para desactivar/activar (útil para admin)
    @Transactional
    public void toggleActive(Integer examId, boolean active) {
        Exams exam = examRepo.findById(examId)
                .orElseThrow(() -> new IllegalArgumentException("Examen no encontrado: " + examId));

        exam.setIsActive(active);
        examRepo.save(exam);
    }

    @Transactional
    public Exams updateExam(Integer id, Exams updated) {
        Exams existing = findById(id);
        if (existing == null) {
            throw new IllegalArgumentException("Examen no encontrado");
        }

        // Copiar campos permitidos
        existing.setExamname(updated.getExamname());
        existing.setDescription(updated.getDescription());
        existing.setIcon(updated.getIcon());
        // No tocar isActive aquí, mejor con toggleActive

        return examRepo.save(existing);
    }
}

