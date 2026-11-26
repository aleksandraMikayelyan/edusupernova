package com.edusupernova.edusupernova.test.service.evaluation;

import com.edusupernova.edusupernova.model.TestQuestions;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
@Order(2)
public class IeltsTask1GeneralStrategy implements EvaluationStrategy {

    private static final ExamProfile PROFILE = new ExamProfile(
        "IELTS General Training Writing Task 1",
        """
        Cambridge IELTS General Training Writing Task 1 — four equally-weighted criteria (band 0–9):

        1. Task Achievement
           - Are ALL bullet points from the task prompt fully addressed (minimum detail for each)?
           - Is the PURPOSE of the letter clear and appropriate (complaint, request, explanation, \
        apology, invitation)?
           - Is the REGISTER (formal / semi-formal / informal) correct for the stated audience, \
        and maintained consistently throughout?
           - Are opening and closing conventions correct for the register \
        (Dear Sir/Madam … Yours faithfully; Dear Mr Smith … Yours sincerely; Dear John … Best wishes)?

        2. Coherence & Cohesion
           - Does the letter flow from opening → purpose → body → polite closing?
           - Are linking phrases register-appropriate rather than academic (By the way / Furthermore)?

        3. Lexical Resource
           - Is vocabulary matched to the register?
           - Are polite request or apology formulae accurate \
        (I would be grateful if you could…; I apologise for…)?

        4. Grammatical Range & Accuracy
           - Variety of structures appropriate to letter-writing.
           - Accurate use of conditionals, modal verbs, and subordinate clauses.
        """,
        """
        Score each criterion 0–9 (half-bands permitted). \
        Mean of four bands → round to nearest 0.5 → multiply by %s (cap at 10). \
        A letter that ignores one or more bullet points cannot exceed Band 5 on Task Achievement. \
        A letter with the wrong register (e.g., informal to a company director) is capped at Band 5 overall. \
        A blank response scores Band 0. \
        Report each criterion band and the overall band.\
        """.formatted(StrategyUtils.IELTS_BAND_TO_TEN_MULTIPLIER)
    );

    @Override
    public boolean supports(String examName, String paperName, List<TestQuestions> answers) {
        String exam  = StrategyUtils.normalise(examName);
        String paper = StrategyUtils.normalise(paperName);
        if (!exam.contains("ielts") || !paper.contains("writing")) return false;
        String groupTitle = StrategyUtils.groupTitle(answers);
        return groupTitle.contains("general task 1") || groupTitle.contains("general training task 1");
    }

    @Override
    public ExamProfile profile() {
        return PROFILE;
    }
}
