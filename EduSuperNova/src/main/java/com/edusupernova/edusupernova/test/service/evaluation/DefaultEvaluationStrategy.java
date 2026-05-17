package com.edusupernova.edusupernova.test.service.evaluation;

import com.edusupernova.edusupernova.model.TestQuestions;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

import java.util.List;

/** Catch-all strategy applied when no more specific profile matches. Always returns true. */
@Component
@Order(Integer.MAX_VALUE)
public class DefaultEvaluationStrategy implements EvaluationStrategy {

    private static final ExamProfile PROFILE = new ExamProfile(
        "General",
        """
        - Relevance: Does the answer address the question directly and completely?
        - Depth: Is the response well-developed with supporting details or examples?
        - Clarity: Is the writing clear, coherent, and logically organised?
        - Language: Is vocabulary and grammar used accurately and appropriately?
        """,
        "Score 0-10: 8-10=excellent, 6-7=good, 4-5=adequate, 0-3=insufficient."
    );

    @Override
    public boolean supports(String examName, String paperName, List<TestQuestions> answers) {
        return true;
    }

    @Override
    public ExamProfile profile() {
        return PROFILE;
    }
}
