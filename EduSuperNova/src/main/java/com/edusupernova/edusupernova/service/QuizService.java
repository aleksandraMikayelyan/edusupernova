package com.edusupernova.edusupernova.service;

import com.edusupernova.edusupernova.data.QuizRepository;
import com.edusupernova.edusupernova.model.Quiz;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional(readOnly = true)
public class QuizService {

    @Autowired
    private QuizRepository quizRepo;

    // Ahora recibe courseId en lugar de examId
    public List<Quiz> generateRandomTest(int courseId) {
        return quizRepo.generateRandomTest(courseId);
    }

    // Conteo por tipo, ahora por curso
    public int countByType(int courseId, String type) {
        return (int) quizRepo.countByCourseIdAndType(courseId, type);
    }

    // Validación ajustada a curso
    public boolean canGenerateTest(int courseId) {
        long multipleChoiceCount = quizRepo.countByCourseIdAndType(courseId, "multipleChoice");
        long otherTypesCount = quizRepo.countByCourseIdAndType(courseId, "openEnded") +
                quizRepo.countByCourseIdAndType(courseId, "logicalProblems");

        return multipleChoiceCount >= 15 && otherTypesCount >= 5;
    }

    // Opcional: método útil para mostrar info al usuario antes de generar
    public String getQuestionStats(int courseId) {
        long total = quizRepo.countByCourseId(courseId);
        long mc = quizRepo.countByCourseIdAndType(courseId, "multipleChoice");
        long oe = quizRepo.countByCourseIdAndType(courseId, "openEnded");
        long lp = quizRepo.countByCourseIdAndType(courseId, "logicalProblems");

        return String.format("Preguntas disponibles: Total=%d | Multiple Choice=%d | Open Ended=%d | Logical=%d",
                total, mc, oe, lp);
    }
}