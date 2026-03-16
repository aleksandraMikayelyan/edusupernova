package com.edusupernova.edusupernova.dto;

import lombok.Builder;
import lombok.Data;
import java.util.List;

@Data
@Builder
public class TestQuestionDTO {
    private Integer testId;
    private Integer quizId;

    // Quiz info
    private String questionText;
    private Object options; // Could be a String (JSON) or parsed as List/Object depending on your
                            // implementation
    private String type;

    // User progress
    private String userResponse;
    private Boolean correctResponse;
    private Integer punctuation;
    private String feedbackIa;
}
