package com.edusupernova.edusupernova.test.service.evaluation;

import com.edusupernova.edusupernova.model.TestQuestions;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
@Order(10)
public class SatStrategy implements EvaluationStrategy {

    private static final ExamProfile PROFILE = new ExamProfile(
        "SAT Essay",
        """
        Score each dimension 1-4:
        - Reading: Comprehension of the source text, central ideas, important details, use of evidence.
        - Analysis: Quality of argument analysis, examination of evidence, reasoning, and rhetorical elements.
        - Writing: Command of language, vocabulary, sentence variety, organisation, standard conventions.
        """,
        "Sum three dimension scores (range 3-12), map to 0-10: ((sum-3)/9)×10. " +
        "Sum 12=10, sum 9=6.7, sum 6=3.3. Give a score per dimension in feedback."
    );

    @Override
    public boolean supports(String examName, String paperName, List<TestQuestions> answers) {
        return StrategyUtils.normalise(examName).contains("sat");
    }

    @Override
    public ExamProfile profile() {
        return PROFILE;
    }
}
