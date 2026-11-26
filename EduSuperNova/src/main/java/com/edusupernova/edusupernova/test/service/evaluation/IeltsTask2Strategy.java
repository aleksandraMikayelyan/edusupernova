package com.edusupernova.edusupernova.test.service.evaluation;

import com.edusupernova.edusupernova.model.TestQuestions;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
@Order(3)
public class IeltsTask2Strategy implements EvaluationStrategy {

    private static final ExamProfile PROFILE = new ExamProfile(
        "IELTS Academic/General Training Writing Task 2",
        """
        Cambridge IELTS Writing Task 2 — four equally-weighted criteria (band 0–9):

        1. Task Response
           - Is a clear, consistent position taken and maintained (opinion essays)?
           - Are ALL parts of the question addressed — e.g., two views + own opinion; \
        advantages AND disadvantages; causes AND solutions?
           - Is the conclusion consistent with the thesis, not a new argument?
           - Are ideas relevant, supported with examples, and extended beyond the obvious?

        2. Coherence & Cohesion
           - Clear introduction (paraphrase + thesis) → body paragraphs (topic sentence + \
        support + link) → conclusion.
           - Cohesive devices used correctly without over-use \
        (avoid starting every sentence with Firstly / Secondly / Finally).
           - Referencing and substitution used to avoid repetition.

        3. Lexical Resource
           - Academic register; topic-specific vocabulary used accurately.
           - The prompt is paraphrased, not copied verbatim.
           - Accurate collocations, spelling, and word form.

        4. Grammatical Range & Accuracy
           - Mix of simple, compound, and complex sentences.
           - Accurate conditionals, relative clauses, passive voice, and discourse markers.
           - Errors assessed for frequency and impact on communication.
        """,
        """
        Score each criterion 0–9 (half-bands permitted). \
        Mean → round to nearest 0.5 → multiply by %s (cap at 10). \
        An essay that addresses only part of the question cannot exceed Band 5 on Task Response. \
        A blank or entirely off-topic essay scores Band 0. \
        Report each criterion band and the overall band.\
        """.formatted(StrategyUtils.IELTS_BAND_TO_TEN_MULTIPLIER)
    );

    @Override
    public boolean supports(String examName, String paperName, List<TestQuestions> answers) {
        String exam  = StrategyUtils.normalise(examName);
        String paper = StrategyUtils.normalise(paperName);
        if (!exam.contains("ielts") || !paper.contains("writing")) return false;
        String groupTitle = StrategyUtils.groupTitle(answers);
        // Task 2 essays are seeded without a question group (idquestiongroup IS NULL), unlike
        // Task 1 responses which always belong to a group titled "... Task 1" — that's why the
        // positive "task 2"/"40 minutes"/"250 words" markers below never match real data (those
        // strings only ever appear in the Paper's instructions field). Since this strategy only
        // runs after both Task 1 strategies have had a chance to match on their title markers,
        // an ungrouped IELTS Writing answer reaching this point is a Task 2 answer by elimination.
        return groupTitle.contains("task 2")
                || StrategyUtils.questionTextContains(answers, "40 minutes")
                || StrategyUtils.questionTextContains(answers, "250 words")
                || groupTitle.isBlank();
    }

    @Override
    public ExamProfile profile() {
        return PROFILE;
    }
}
