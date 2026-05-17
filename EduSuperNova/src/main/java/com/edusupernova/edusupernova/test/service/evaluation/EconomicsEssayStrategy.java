package com.edusupernova.edusupernova.test.service.evaluation;

import com.edusupernova.edusupernova.model.TestQuestions;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
@Order(6)
public class EconomicsEssayStrategy implements EvaluationStrategy {

    private static final ExamProfile PROFILE = new ExamProfile(
        "Cambridge 9708 AS/A Level Economics — Essay (Section B)",
        """
        Cambridge 9708 Paper 2 Section B — level-descriptor rubric. \
        Determine whether this is an 8-mark or 12-mark question from the question text.

        Assessment Objectives:
        AO1 Knowledge    — correct definitions, economic concepts, specialist terminology.
        AO2 Application  — applying theory to the specific context; real-world or stimulus examples.
        AO3 Analysis     — chains of reasoning (if X → then Y → because Z); \
                           correctly labelled diagrams (AD/AS, supply/demand, cost curves).
        AO4 Evaluation   — weighing competing arguments; short-run vs long-run trade-offs; \
                           assumptions challenged; government failure vs market failure; \
                           justified conclusion — NOT just restating the analysis.

        FOR 8-MARK QUESTIONS (part a — explain / analyse):
        Level 3 (7–8 marks): Accurate knowledge, clear application, well-developed analytical \
        chain. Evaluation present but not required.
        Level 2 (4–6 marks): Some accurate knowledge; partial analytical chain; \
        limited application to context.
        Level 1 (1–3 marks): Superficial or descriptive; little or no analytical chain.
        0 marks: blank, off-topic, or no economic content.

        FOR 12-MARK QUESTIONS (part b — discuss / evaluate):
        Level 3 (9–12 marks): Comprehensive AO3 analysis AND substantive AO4 evaluation — \
        arguments weighed, trade-offs identified, justified conclusion drawn. \
        Diagrams accurately deployed where relevant.
        Level 2 (5–8 marks): Some analysis; evaluation present but limited or unsubstantiated. \
        Conclusion may be asserted rather than reasoned.
        Level 1 (1–4 marks): Mostly descriptive; analysis absent or superficial; no evaluation.
        0 marks: blank or off-topic.
        IMPORTANT: An essay with strong analysis but NO evaluation cannot exceed Level 2 on a 12-mark question.
        """,
        """
        Identify from the question text whether this is an 8-mark or 12-mark question. \
        Assign a Level (1, 2, or 3) and a specific mark within that level. \
        Convert to 0–10: for 8-mark → (marks/8)×10; for 12-mark → (marks/12)×10. \
        A blank or off-topic answer scores 0. \
        In the feedback: state the level awarded and the deciding factor \
        (e.g., "good analysis but no evaluation — capped at Level 2"); \
        identify the specific AO that was weakest; \
        name one concrete economic argument or diagram that would have lifted the response to the next level.\
        """
    );

    @Override
    public boolean supports(String examName, String paperName, List<TestQuestions> answers) {
        return StrategyUtils.normalise(examName).contains("econom");
    }

    @Override
    public ExamProfile profile() {
        return PROFILE;
    }
}
