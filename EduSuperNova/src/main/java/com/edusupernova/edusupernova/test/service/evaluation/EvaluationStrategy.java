package com.edusupernova.edusupernova.test.service.evaluation;

import com.edusupernova.edusupernova.model.TestQuestions;

import java.util.List;

public interface EvaluationStrategy {
    boolean supports(String examName, String paperName, List<TestQuestions> answers);
    ExamProfile profile();
}
