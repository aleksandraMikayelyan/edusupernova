package com.edusupernova.edusupernova.test.service.evaluation;

import com.edusupernova.edusupernova.model.TestQuestions;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
@Order(7)
public class EnglishPaper1Strategy implements EvaluationStrategy {

    private static final ExamProfile PROFILE = new ExamProfile(
        "Cambridge 9093 AS English Language — Paper 1 (Passages)",
        """
        Cambridge 9093 English Language Paper 1 rubric. \
        Two sections: Section A (Reading & Writing) and Section B (Directed Writing).

        SECTION A — READING QUESTIONS (summary or language analysis):

        R — Reading (up to 15 marks):
        - Accuracy and completeness of information selected from the passage.
        - Use of own words — lifting whole phrases verbatim is penalised.
        - Conciseness, coherence, and relevance of summary points.

        W — Language Analysis (up to 15 marks):
        - Correct identification of linguistic and stylistic features using precise terminology \
        (e.g., tricolon, imperative, anaphora, hyperbole, assonance, juxtaposition, \
        rhetorical question, syndeton, polysyndeton, semantic field, register shift).
        - Explanation of the EFFECT of each feature on the reader — naming a technique without \
        explaining its effect receives only partial credit.
        - Each point must be supported by a short, accurately embedded quotation.
        - Avoid vague comments ("This makes the reader feel interested"); be precise about effect.

        SECTION B — DIRECTED WRITING (25 marks = W1 + W2):

        W1 Content & Audience (15 marks):
        - Has the correct FORM been adopted and sustained \
        (letter, speech, article, report, leaflet, blog post)?
        - Is the AUDIENCE correctly identified and addressed throughout \
        (vocabulary level, assumed knowledge, tone)?
        - Is the PURPOSE achieved (persuade, inform, advise, explain, entertain)?
        - Is source material SELECTED and TRANSFORMED — not copied verbatim from the passage?
        Band 1 (13–15): Form, audience, and purpose fully and consistently achieved; \
        sophisticated selection and adaptation of source material.
        Band 2 (10–12): Mostly achieved; minor lapses in form or audience awareness.
        Band 3 (7–9): Some awareness; form inconsistently maintained; purpose partially achieved.
        Band 4 (4–6): Limited sense of form or audience; largely copies source material.
        Band 5 (1–3): Little attempt at appropriate form or audience.

        W2 Style & Accuracy (10 marks):
        - Register is consistently appropriate to the chosen form and audience.
        - Vocabulary range and precision; avoidance of repetition.
        - Variety of sentence structures used for effect.
        - Accuracy of grammar, punctuation, and spelling.
        Band 1 (9–10): Sophisticated; virtually no errors; structures used for deliberate effect.
        Band 2 (7–8): Competent variety; occasional minor errors.
        Band 3 (5–6): Generally appropriate; errors present but not impeding.
        Band 4 (3–4): Limited variety; frequent errors.
        Band 5 (1–2): Very limited; errors seriously impede communication.
        """,
        """
        For Section A reading/summary questions: score R out of 15 and W out of 15; \
        convert to 0–10 using (R+W)/3. \
        For Section B Directed Writing: score W1 out of 15 and W2 out of 10; \
        convert to 0–10 using (W1+W2)/%s. \
        A blank response or one that ignores the specified form and audience scores 0 on the relevant criterion. \
        In the feedback: for language analysis, name every technique identified with its correct \
        linguistic label and comment on whether its effect was explained; \
        for directed writing, state whether form/audience/purpose were achieved and \
        flag any register inconsistencies with a specific example.\
        """.formatted(StrategyUtils.DIRECTED_WRITING_SCORE_DIVISOR)
    );

    @Override
    public boolean supports(String examName, String paperName, List<TestQuestions> answers) {
        String exam  = StrategyUtils.normalise(examName);
        String paper = StrategyUtils.normalise(paperName);
        if (exam.contains("toefl") || exam.contains("act")) return false;
        if (!exam.contains("english")) return false;
        return paper.contains("paper 1") || paper.contains("paper1");
    }

    @Override
    public ExamProfile profile() {
        return PROFILE;
    }
}
