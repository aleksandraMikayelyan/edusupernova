package com.edusupernova.edusupernova.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import java.util.List;

@Data
@AllArgsConstructor
public class FeedBackDTO {
    private String testMark;
    private List<QuestionFeedbackDTO> questionsFeedback;

    @Data
    @AllArgsConstructor
    public static class QuestionFeedbackDTO {
        private Integer id;
        private String text;
        private String aiCorrection;
    }
}