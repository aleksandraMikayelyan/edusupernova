package com.edusupernova.edusupernova.test.service;

import com.edusupernova.edusupernova.test.dto.request.SubmitAnswerRequest;
import com.edusupernova.edusupernova.test.dto.response.AnswerFeedbackDTO;
import com.edusupernova.edusupernova.model.TestQuestions;
import com.edusupernova.edusupernova.model.Tests;

import java.util.List;

public interface ITestSubmissionService {

    AnswerFeedbackDTO submitAnswer(Integer testId, SubmitAnswerRequest request, String email);

    boolean saveAnswers(Integer testId, List<TestQuestions> userAnswers);

    /**
     * Batch-evaluates any open-ended question that was answered but has no valid AI score yet
     * (e.g. a prior per-answer evaluation failed). Shared by both the normal completion path
     * and force-submit, so neither can finalize a test while silently dropping a real answer
     * from scoring.
     */
    void evaluatePendingOpenEnded(Tests test, List<TestQuestions> allQuestions);
}
