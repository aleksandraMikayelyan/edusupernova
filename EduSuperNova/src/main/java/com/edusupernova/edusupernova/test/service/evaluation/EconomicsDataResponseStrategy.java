package com.edusupernova.edusupernova.test.service.evaluation;

import com.edusupernova.edusupernova.model.Quiz;
import com.edusupernova.edusupernova.model.TestQuestions;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
@Order(5)
public class EconomicsDataResponseStrategy implements EvaluationStrategy {

    private static final ExamProfile PROFILE = new ExamProfile(
        "Cambridge 9708 AS/A Level Economics — Data Response (Section A)",
        """
        Cambridge 9708 Paper 2 Section A — mark-point rubric. \
        The mark allocation is embedded in the question (e.g., [2], [4]). \
        Apply the correct standard for each question type:

        DEFINE questions (1–2 marks)
           1 mark: basic identification of the concept.
           2 marks: precise economic definition using correct specialist terminology, \
        with no ambiguity. Penalise circular definitions and everyday-language descriptions.

        CALCULATE questions (2–4 marks)
           Award full marks only if method is correct AND the final numerical answer is \
        accurate with correct units or percentage signs. \
        Award method marks (mark – 1) for correct approach with arithmetic error. \
        Show that working-out has been evaluated; unsupported answers score 0 for method.

        EXPLAIN / ANALYSE questions (4 marks) — point-based:
           • Identify the relevant economic concept, variable, or direction of change  (1 mark)
           • State the mechanism using a causal chain (if X → then Y → because Z)       (1 mark)
           • Apply the analysis explicitly to the data or context in the stimulus        (1 mark)
           • Extend with a further consequence, qualification, or limiting factor        (1 mark)
        Generic answers that could apply to any context and ignore the stimulus score ≤ 2/4.

        Relevant economic frameworks: supply and demand, PED/PES/YED/XED, market structures \
        (perfect competition, monopoly, oligopoly), macroeconomic objectives (low inflation, \
        low unemployment, economic growth, BoP equilibrium), AD/AS model, \
        fiscal/monetary/supply-side policy, international trade and exchange rates, \
        development economics indicators.
        """,
        """
        Identify the question type (define / calculate / explain / analyse) from the question text \
        and estimate the mark allocation. Map marks earned to 0–10: (marks_earned / marks_available) × 10. \
        A blank answer or one that does not address the economic question scores 0/10. \
        In the feedback: state the question type, the marks awarded and why, \
        name any specific economic term or data point the candidate omitted or misused, \
        and give one concrete example of the chain of reasoning that was missing.\
        """
    );

    @Override
    public boolean supports(String examName, String paperName, List<TestQuestions> answers) {
        String exam = StrategyUtils.normalise(examName);
        if (!exam.contains("econom")) return false;
        Quiz.QuestionType type = StrategyUtils.firstQuestionType(answers);
        return type == Quiz.QuestionType.SHORT_ANSWER;
    }

    @Override
    public ExamProfile profile() {
        return PROFILE;
    }
}
