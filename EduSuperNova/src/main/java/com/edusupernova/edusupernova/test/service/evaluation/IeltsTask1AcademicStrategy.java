package com.edusupernova.edusupernova.test.service.evaluation;

import com.edusupernova.edusupernova.model.TestQuestions;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
@Order(1)
public class IeltsTask1AcademicStrategy implements EvaluationStrategy {

    private static final ExamProfile PROFILE = new ExamProfile(
        "IELTS Academic Writing Task 1",
        """
        Cambridge IELTS Academic Writing Task 1 — four equally-weighted criteria (band 0–9):

        1. Task Achievement
           - Is there a clear overview of the most significant feature(s) or trend(s)?
           - Are key features selected and reported accurately using data from the visual?
           - Are comparisons made where relevant (highest/lowest, change over time)?
           - Is irrelevant detail avoided? No personal opinion should appear.

        2. Coherence & Cohesion
           - Is the response logically organised: overview → body paragraphs?
           - Are cohesive devices used accurately and not mechanically repeated \
        (however, in contrast, whereas, by comparison, similarly)?
           - Is referencing (it, this, these) handled correctly?

        3. Lexical Resource
           - Is data-description vocabulary accurate: peaked, declined sharply, fluctuated, \
        accounted for, constituted, remained stable, saw a dramatic rise?
           - Are collocations correct? Is spelling accurate?
           - Is vocabulary varied, avoiding repetition of the same word or phrase?

        4. Grammatical Range & Accuracy
           - Are passive constructions, comparatives, superlatives, and complex sentences used?
           - What is the frequency and severity of grammatical errors?
        """,
        """
        Score each criterion on the IELTS band scale 0–9 (half-bands permitted: 5.5, 6.5, etc.). \
        Compute the mean of the four bands, round to the nearest 0.5, then convert to 0–10: \
        band × 1.111 (cap at 10). Band 9=10, Band 8=8.9, Band 7=7.8, Band 6=6.7, Band 5=5.6, Band 4=4.4. \
        A response that does not describe the visual, ignores the data, or is blank scores Band 0 \
        on Task Achievement and will result in a very low overall score. \
        Report the band for every criterion and the overall band in the feedback.\
        """
    );

    @Override
    public boolean supports(String examName, String paperName, List<TestQuestions> answers) {
        String exam  = StrategyUtils.normalise(examName);
        String paper = StrategyUtils.normalise(paperName);
        if (!exam.contains("ielts") || !paper.contains("writing")) return false;
        String groupTitle = StrategyUtils.groupTitle(answers);
        return groupTitle.contains("academic task 1") || groupTitle.contains("academic writing task 1");
    }

    @Override
    public ExamProfile profile() {
        return PROFILE;
    }
}
