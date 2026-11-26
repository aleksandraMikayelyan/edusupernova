package com.edusupernova.edusupernova.test.service.evaluation;

import com.edusupernova.edusupernova.model.TestQuestions;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
@Order(8)
public class EnglishPaper2Strategy implements EvaluationStrategy {

    private static final ExamProfile PROFILE = new ExamProfile(
        "Cambridge 9093 AS English Language — Paper 2 (Writing)",
        """
        Cambridge 9093 English Language Paper 2 rubric (25 marks = W1 + W2). \
        The candidate selects one task from five writing modes: \
        narrative, descriptive, explanatory, argumentative, or discursive.

        W1 — Content & Structure (15 marks):
        Band 1 (13–15): Sophisticated and fully controlled. Ideas are original and \
        convincingly developed. Structure serves the chosen mode perfectly \
        (discursive: clear thesis → developed paragraphs → balanced, nuanced conclusion; \
        narrative: effective opening hook → rising tension → satisfying resolution; \
        descriptive: sustained atmosphere, precise sensory detail throughout; \
        argumentative: clear stance → evidence chain → counter-argument addressed → \
        reinforced conclusion).
        Band 2 (10–12): Fluent and effective. Good organisation; mostly consistent development.
        Band 3 (7–9): Competent. Structure evident but may be formulaic or underdeveloped.
        Band 4 (4–6): Some attempt to organise ideas; limited or repetitive development.
        Band 5 (1–3): Little control of structure; ideas barely developed.
        0: Blank or entirely irrelevant.

        W2 — Style & Accuracy (10 marks):
        Band 1 (9–10): Sophisticated, precise vocabulary. Sentence structures deliberately varied \
        for stylistic effect. Virtually no errors in grammar, spelling, or punctuation.
        Band 2 (7–8): Competent range of structures and vocabulary. Occasional minor errors.
        Band 3 (5–6): Generally appropriate register. Some structural variety. \
        Errors present but not impeding comprehension.
        Band 4 (3–4): Limited vocabulary range. Mostly simple sentences. Errors frequent.
        Band 5 (1–2): Very limited control. Errors seriously impede communication.
        0: Blank.

        Mode-specific markers of quality:
        Narrative/Descriptive: vivid imagery, varied sentence rhythm, narrative voice maintained, \
        showing not telling, sensory details, effective pacing.
        Argumentative: logical evidence chain, acknowledgement and refutation of counter-arguments, \
        persuasive devices (rhetorical questions, rule of three, direct address).
        Discursive: balanced exploration of perspectives, hedging language \
        (it could be argued, while some believe), nuanced conclusion.
        Explanatory: clear sequencing (firstly/subsequently/finally), accessible register, \
        concrete examples, avoidance of jargon without definition.
        """,
        """
        Score W1 out of 15 (Content & Structure) and W2 out of 10 (Style & Accuracy). \
        Convert to 0–10 using (W1 + W2) / %s. \
        A blank response or one that does not attempt the chosen mode scores 0. \
        In the feedback: identify the mode chosen by the candidate; \
        comment on structural control with one specific example (quote a line if needed); \
        note vocabulary and sentence variety; \
        flag any grammar, spelling, or punctuation errors that impede communication.\
        """.formatted(StrategyUtils.DIRECTED_WRITING_SCORE_DIVISOR)
    );

    @Override
    public boolean supports(String examName, String paperName, List<TestQuestions> answers) {
        String exam  = StrategyUtils.normalise(examName);
        String paper = StrategyUtils.normalise(paperName);
        if (exam.contains("toefl") || exam.contains("act")) return false;
        if (!exam.contains("english")) return false;
        return paper.contains("paper 2") || paper.contains("paper2");
    }

    @Override
    public ExamProfile profile() {
        return PROFILE;
    }
}
