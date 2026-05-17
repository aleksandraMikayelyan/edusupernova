package com.edusupernova.edusupernova.test.service;

import com.edusupernova.edusupernova.test.dto.request.StartTestRequest;
import com.edusupernova.edusupernova.test.dto.response.TestSessionDTO;
import com.edusupernova.edusupernova.model.TestQuestions;
import com.edusupernova.edusupernova.model.Tests;

import java.util.List;

public interface ITestSessionService {

    TestSessionDTO startTest(StartTestRequest request, String email);

    TestSessionDTO getSession(Integer testId, String email);

    long getRemainingSeconds(Tests test);

    List<TestQuestions> getQuestionsByTestId(Integer testId);
}
