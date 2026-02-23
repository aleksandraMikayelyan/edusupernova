package com.edusupernova.edusupernova.controller;

import com.edusupernova.edusupernova.model.TestQuestions;
import com.edusupernova.edusupernova.service.EvaluationService;
import com.edusupernova.edusupernova.service.TestService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/tests")
@RequiredArgsConstructor
@CrossOrigin(origins = "*") // Allows your mobile app to connect
public class TestController {

    private final EvaluationService evaluationService;
    private final TestService testService;
    /**
     * Paso 1: El usuario selecciona una materia en React Native y se crea el test.
     * Devuelve el ID del test para que el front sepa dónde guardar las respuestas.
     */
    @PostMapping("/start")
    public ResponseEntity<Integer> startTest(@RequestParam Integer userId, @RequestParam Integer courseId) {
        int testId = testService.crearTest(userId, courseId);
        return ResponseEntity.ok(testId);
    }

    /**
     * Paso 2: El usuario termina el test.
     * Recibimos la lista de respuestas, las guardamos y disparamos la evaluación IA.
     */
    @PostMapping("/{testId}/evaluate")
    public ResponseEntity<EvaluationService.TestEvaluationResult> completeAndEvaluate(
            @PathVariable Integer testId,
            @RequestBody List<TestQuestions> answers,
            @RequestParam String examType,
            @RequestParam String sectionName) {

        // 1. Guardamos las respuestas en la base de datos
        boolean saved = testService.saveAnswers(testId, answers);

        if (!saved) {
            return ResponseEntity.internalServerError().build();
        }

        // 2. Ejecutamos la evaluación (Lógica 0-10 con IA que corregimos antes)
        EvaluationService.TestEvaluationResult result =
                evaluationService.evaluateTest(testId, examType, sectionName);

        return ResponseEntity.ok(result);
    }
}
