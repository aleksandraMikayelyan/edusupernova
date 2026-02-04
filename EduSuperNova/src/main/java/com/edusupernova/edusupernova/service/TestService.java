package com.edusupernova.edusupernova.service;


import com.edusupernova.edusupernova.data.*;
import com.edusupernova.edusupernova.model.Courses;
import com.edusupernova.edusupernova.model.TestQuestions;
import com.edusupernova.edusupernova.model.Tests;
import com.edusupernova.edusupernova.model.Users;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class TestService {

    @Autowired
    private TestRepository testRepo;

    @Autowired
    private TestQuestionsRepository testQuestionRepo;

    @Autowired
    private UserRepository userRepo;

    @Autowired
    private CourseRepository courseRepo;

    // 1. Crear test vacío para un curso específico
    @Transactional
    public int crearTest(Integer userId, Integer courseId) {
        Users user = userRepo.findById(userId)
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));

        Courses course = courseRepo.findById(courseId)
                .orElseThrow(() -> new RuntimeException("Curso no encontrado"));

        // Opcional: validar que el usuario está inscrito en el examen del curso
        // examRepo.findById(course.getExam().getIdExam()) ...

        Tests test = new Tests();  // ← usa la clase con nombre singular
        test.setUser(user);
        test.setCourse(course);
        test.setCreationDate(LocalDateTime.now());

        Tests saved = testRepo.save(test);
        return saved.getId();  // ← si usas idTest en la entidad
    }

    // 2. Guardar respuestas (con validación básica)
    @Transactional
    public boolean saveAnswers(Integer testId, List<TestQuestions> answers) {
        try {
            Tests test = testRepo.findById(testId)
                    .orElseThrow(() -> new RuntimeException("Test no encontrado"));

            // Validación extra: todas las preguntas deben pertenecer al curso del test
            Integer courseId = test.getCourse().getIdCourse();
            for (TestQuestions tq : answers) {
                if (tq.getQuiz() == null || !tq.getQuiz().getCourse().getIdCourse().equals(courseId)) {
                    throw new IllegalArgumentException("Pregunta no pertenece al curso del test");
                }

                tq.setTest(test);
                tq.getId().setIdTest(testId);  // clave compuesta

                // Opcional: calcular si es correcta y asignar puntuación/feedback aquí
                // boolean esCorrecta = tq.getUserResponse().equals(tq.getQuiz().getCorrectAnswer());
                // tq.setCorrectResponse(esCorrecta);
                // tq.setPunctuation(esCorrecta ? 1 : 0);
            }

            testQuestionRepo.saveAll(answers);
            return true;
        } catch (Exception e) {
            // En producción: loggear mejor (logger.error(...))
            e.printStackTrace();
            return false;
        }
    }

    // 3. Calcular y guardar puntuación final (mejor que updatePunctuation)
    @Transactional
    public int calcularYGuardarPuntuacion(Integer testId) {
        Tests test = testRepo.findById(testId)
                .orElseThrow(() -> new RuntimeException("Test no encontrado"));

        long correctas = testQuestionRepo.countByTestIdAndCorrectResponseTrue(testId);
        long total = testQuestionRepo.countByTestId(testId);

        int puntuacion = total > 0 ? (int) Math.round((correctas * 100.0) / total) : 0;

        // Si decides agregar campo punctuation a Test:
        // test.setPunctuation(puntuacion);
        // testRepo.save(test);

        return puntuacion;  // Devuelves el valor calculado
    }

    // Bonus: obtener test completo con respuestas
    @Transactional
    public Tests obtenerTestConRespuestas(Integer testId) {
        return testRepo.findById(testId).orElse(null);
        // Si necesitas eager loading de answers: usar @EntityGraph o fetch join en query
    }
}

