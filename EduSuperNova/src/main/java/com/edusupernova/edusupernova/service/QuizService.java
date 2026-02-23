package com.edusupernova.edusupernova.service;

import com.edusupernova.edusupernova.data.QuizRepository;
import com.edusupernova.edusupernova.model.Quiz;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

@Service
@Transactional(readOnly = true)
public class QuizService {

    @Autowired
    private QuizRepository quizRepo;



    public List<Quiz> generateRandomTest(int courseId) {
        // 1. Fetch and Shuffle Multiple Choice
        List<Quiz> allMc = quizRepo.findByCourseIdAndType(courseId, "multipleChoice");
        Collections.shuffle(allMc);
        List<Quiz> selectedMc = allMc.stream().limit(15).toList();

        // 2. Fetch and Shuffle Open Ended / Logical
        List<Quiz> allOpen = quizRepo.findByCourseIdAndTypeIn(
                courseId, List.of("openEnded", "logicalProblems")
        );
        Collections.shuffle(allOpen);
        List<Quiz> selectedOpen = allOpen.stream().limit(5).toList();

        // 3. Combine both lists
        List<Quiz> finalTest = new ArrayList<>();
        finalTest.addAll(selectedMc);
        finalTest.addAll(selectedOpen);

        // Optional: Shuffle the final list so MC and Open Ended are mixed
        Collections.shuffle(finalTest);

        return finalTest;
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