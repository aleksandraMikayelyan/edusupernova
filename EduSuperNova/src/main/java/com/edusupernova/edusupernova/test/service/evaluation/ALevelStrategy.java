package com.edusupernova.edusupernova.test.service.evaluation;

import com.edusupernova.edusupernova.model.TestQuestions;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
@Order(12)
public class ALevelStrategy implements EvaluationStrategy {

    private static final ExamProfile PROFILE = new ExamProfile(
        "A Level / AS Level",
        """
        - AO1 Knowledge & Understanding: Accurate, relevant subject knowledge and use of specialist terminology.
        - AO2 Application: Application of knowledge to the question; examples, data, or theory.
        - AO3 Analysis & Evaluation: Logical analysis, evaluation of competing arguments, balanced conclusions.
        - Quality of Written Communication: Clarity, structure, spelling, grammar, academic register.
        """,
        "Score 0-10: 8-10=distinction (A/A*), 6-7=merit (B/C), 4-5=pass (D/E), 0-3=below pass. " +
        "Comment on each AO with actionable suggestions."
    );

    @Override
    public boolean supports(String examName, String paperName, List<TestQuestions> answers) {
        return StrategyUtils.normalise(examName).contains("level");
    }

    @Override
    public ExamProfile profile() {
        return PROFILE;
    }
}
