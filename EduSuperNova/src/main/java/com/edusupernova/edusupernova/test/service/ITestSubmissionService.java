package com.edusupernova.edusupernova.test.service;

import com.edusupernova.edusupernova.test.dto.request.SubmitAnswerRequest;
import com.edusupernova.edusupernova.test.dto.response.AnswerFeedbackDTO;
import com.edusupernova.edusupernova.model.TestQuestions;

import java.util.List;

public interface ITestSubmissionService {

    AnswerFeedbackDTO submitAnswer(Integer testId, SubmitAnswerRequest request, String email);

    boolean saveAnswers(Integer testId, List<TestQuestions> userAnswers);
}
