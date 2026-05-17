package com.edusupernova.edusupernova.test.service.evaluation;

import com.edusupernova.edusupernova.model.TestQuestions;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

import java.util.List;

/** Catch-all for IELTS Writing when the sub-task (Academic T1 / General T1 / T2) cannot be determined. */
@Component
@Order(4)
public class IeltsWritingFallbackStrategy implements EvaluationStrategy {

    private static final ExamProfile PROFILE = new ExamProfile(
        "IELTS Writing",
        """
        Cambridge IELTS Writing — four equally-weighted criteria (band 0–9):
        Task Achievement/Response, Coherence & Cohesion, Lexical Resource, Grammatical Range & Accuracy.
        Apply the standard Cambridge IELTS Writing band descriptors for each criterion.
        """,
        """
        Score each criterion 0–9 (half-bands permitted). \
        Mean → round to nearest 0.5 → multiply by 1.111 (cap at 10). \
        Report each criterion band and the overall band.\
        """
    );

    @Override
    public boolean supports(String examName, String paperName, List<TestQuestions> answers) {
        String exam  = StrategyUtils.normalise(examName);
        String paper = StrategyUtils.normalise(paperName);
        return exam.contains("ielts") && paper.contains("writing");
    }

    @Override
    public ExamProfile profile() {
        return PROFILE;
    }
}
