package com.edusupernova.edusupernova.test.service;

import com.edusupernova.edusupernova.test.dto.response.FeedBackDTO;
import com.edusupernova.edusupernova.test.dto.response.TestHistoryDTO;

import java.util.List;

public interface ITestReportService {

    FeedBackDTO getReport(Integer testId, String email);

    FeedBackDTO forceSubmit(Integer testId, String email);

    List<TestHistoryDTO> getHistory(String email);
}
