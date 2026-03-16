package com.edusupernova.edusupernova.service;

import com.edusupernova.edusupernova.data.*;
import com.edusupernova.edusupernova.model.Courses;
import com.edusupernova.edusupernova.model.Quiz;
import com.edusupernova.edusupernova.model.TestQuestionId;
import com.edusupernova.edusupernova.model.TestQuestions;
import com.edusupernova.edusupernova.model.Tests;
import com.edusupernova.edusupernova.model.Users;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.ArrayList;
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

    @Autowired
    private QuizRepository quizRepo;

    // 1. Crear test vacío para un curso específico
    @Transactional
    public int crearTest(Integer userId, Integer courseId) {
        Users user = userRepo.findById(userId)
                .orElseThrow(() -> new RuntimeException("User Not Found"));

        Courses course = courseRepo.findById(courseId)
                .orElseThrow(() -> new RuntimeException("Course Not Found"));

        // Opcional: validar que el usuario está inscrito en el examen del curso
        // examRepo.findById(course.getExam().getIdExam()) ...

        Tests test = new Tests(); // ← usa la clase con nombre singular
        test.setUser(user);
        test.setCourse(course);
        test.setCreationDate(LocalDateTime.now());

        Tests saved = testRepo.save(test);

        List<Quiz> courseQuizzes = quizRepo.findByCourseId(courseId);
        List<TestQuestions> newQuestions = new ArrayList<>();

        for (Quiz q : courseQuizzes) {
            TestQuestions tq = new TestQuestions();
            TestQuestionId tqId = new TestQuestionId();
            tqId.setTestId(saved.getId());
            tqId.setQuizId(q.getId());

            tq.setId(tqId);
            tq.setTest(saved);
            tq.setQuiz(q);
            tq.setUserResponse("");
            tq.setCorrectResponse(false);
            tq.setPunctuation(0);

            newQuestions.add(tq);
        }

        if (!newQuestions.isEmpty()) {
            testQuestionRepo.saveAll(newQuestions);
        }

        return saved.getId(); // ← si usas idTest en la entidad
    }

    @Transactional
    public int crearTestByEmail(String email, Integer courseId) {
        Users user = userRepo.findByEmail(email);
        if (user == null) {
            throw new RuntimeException("User Not Found with email: " + email);
        }

        Courses course = courseRepo.findById(courseId)
                .orElseThrow(() -> new RuntimeException("Course Not Found"));

        Tests test = new Tests();
        test.setUser(user);
        test.setCourse(course);
        test.setCreationDate(LocalDateTime.now());

        Tests saved = testRepo.save(test);

        List<Quiz> courseQuizzes = quizRepo.findByCourseId(courseId);
        List<TestQuestions> newQuestions = new ArrayList<>();

        for (Quiz q : courseQuizzes) {
            TestQuestions tq = new TestQuestions();
            TestQuestionId tqId = new TestQuestionId();
            tqId.setTestId(saved.getId());
            tqId.setQuizId(q.getId());

            tq.setId(tqId);
            tq.setTest(saved);
            tq.setQuiz(q);
            tq.setUserResponse("");
            tq.setCorrectResponse(false);
            tq.setPunctuation(0);

            newQuestions.add(tq);
        }

        if (!newQuestions.isEmpty()) {
            testQuestionRepo.saveAll(newQuestions);
        }

        return saved.getId();
    }

    // 2. Guardar respuestas (con validación básica)
    @Transactional
    public boolean saveAnswers(Integer testId, List<TestQuestions> answers) {
        try {
            Tests test = testRepo.findById(testId)
                    .orElseThrow(() -> new RuntimeException("Test not found"));

            // Get existing questions for this test from the database
            List<TestQuestions> existingQuestions = testQuestionRepo.findByIdTestId(testId);

            for (TestQuestions existingTq : existingQuestions) {
                // Find the matching answer from the frontend payload
                for (TestQuestions newTq : answers) {
                    if (newTq.getId() != null && newTq.getId().getQuizId().equals(existingTq.getId().getQuizId())) {
                        existingTq.setUserResponse(newTq.getUserResponse());
                        break;
                    }
                }
            }

            testQuestionRepo.saveAll(existingQuestions);
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
                .orElseThrow(() -> new RuntimeException("Test not found"));

        long correctas = testQuestionRepo.countByTestIdAndCorrectResponseTrue(testId);
        long total = testQuestionRepo.countByTestId(testId);

        int puntuacion = total > 0 ? (int) Math.round((correctas * 100.0) / total) : 0;

        // Si decides agregar campo punctuation a Test:
        // test.setPunctuation(puntuacion);
        // testRepo.save(test);

        return puntuacion; // Devuelves el valor calculado
    }

    // Bonus: obtener test completo con respuestas
    @Transactional
    public Tests obtenerTestConRespuestas(Integer testId) {
        return testRepo.findById(testId).orElse(null);
        // Si necesitas eager loading de answers: usar @EntityGraph o fetch join en
        // query
    }

    // Obtener la lista de preguntas vinculadas a un test específico
    public List<TestQuestions> getQuestionsByTestId(Integer testId) {
        // Verificamos primero si el test existe
        if (!testRepo.existsById(testId)) {
            throw new RuntimeException("Test not found with id: " + testId);
        }

        // Asumiendo que tu repository tiene este método derivado o una @Query
        return testQuestionRepo.findByIdTestId(testId);
    }
}
