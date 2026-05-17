package com.edusupernova.edusupernova.test.service.evaluation;

import com.edusupernova.edusupernova.model.TestQuestions;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
@Order(11)
public class ActStrategy implements EvaluationStrategy {

    private static final ExamProfile PROFILE = new ExamProfile(
        "ACT Writing",
        """
        Score each domain 1-6:
        - Ideas & Analysis: Depth of engagement; multiple perspectives considered and critiqued.
        - Development & Support: Elaboration with examples, reasoning, and evidence.
        - Organization: Logical sequencing; effective introduction, transitions, and conclusion.
        - Language Use & Conventions: Precision, clarity, grammar, usage, and mechanics.
        """,
        "Average four domain scores (range 1-6), map to 0-10: (average-1)/5×10. " +
        "Average 6=10, average 5=8, average 4=6. Give a score per domain in feedback."
    );

    @Override
    public boolean supports(String examName, String paperName, List<TestQuestions> answers) {
        return StrategyUtils.normalise(examName).contains("act");
    }

    @Override
    public ExamProfile profile() {
        return PROFILE;
    }
}
