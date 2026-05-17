package com.edusupernova.edusupernova.test.service.evaluation;

import com.edusupernova.edusupernova.model.TestQuestions;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
@Order(9)
public class ToeflStrategy implements EvaluationStrategy {

    private static final ExamProfile PROFILE = new ExamProfile(
        "TOEFL Writing",
        """
        - Development & Support: Are main ideas well-developed with specific, relevant details?
        - Organization: Is the essay logically organized with a clear introduction, body, and conclusion?
        - Language Use: Appropriate range and accuracy of grammar, vocabulary, and sentence variety.
        """,
        "Rate on the ETS TOEFL Writing scale (0-5), then multiply by 2 for the 0-10 score. " +
        "Score 5=10, score 4=8, score 3=6, score 2=4. State the TOEFL score equivalent in feedback."
    );

    @Override
    public boolean supports(String examName, String paperName, List<TestQuestions> answers) {
        return StrategyUtils.normalise(examName).contains("toefl");
    }

    @Override
    public ExamProfile profile() {
        return PROFILE;
    }
}
