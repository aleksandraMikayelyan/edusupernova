package com.edusupernova.edusupernova.test.service.evaluation;

import com.edusupernova.edusupernova.model.Quiz;
import com.edusupernova.edusupernova.model.QuestionGroup;
import com.edusupernova.edusupernova.model.TestQuestions;

import java.util.List;
import java.util.Locale;

final class StrategyUtils {

    private StrategyUtils() {}

    /** IELTS band (0-9) → 0-10 scale conversion factor, used by every IELTS Writing strategy. */
    static final double IELTS_BAND_TO_TEN_MULTIPLIER = 1.111;

    /** Divisor for Cambridge 9093 English (W1 + W2) 25-mark directed/content-writing tasks → 0-10 scale. */
    static final double DIRECTED_WRITING_SCORE_DIVISOR = 2.5;

    static String normalise(String s) {
        if (s == null) return "";
        return s.toLowerCase(Locale.ROOT).replace("-", " ").replace("_", " ").trim();
    }

    static String groupTitle(List<TestQuestions> answers) {
        if (answers.isEmpty()) return "";
        QuestionGroup g = answers.get(0).getQuiz().getQuestionGroup();
        return g != null && g.getTitle() != null ? normalise(g.getTitle()) : "";
    }

    static boolean questionTextContains(List<TestQuestions> answers, String keyword) {
        if (answers.isEmpty()) return false;
        String text = answers.get(0).getQuiz().getQuestionText();
        return text != null && text.toLowerCase(Locale.ROOT).contains(keyword.toLowerCase(Locale.ROOT));
    }

    static Quiz.QuestionType firstQuestionType(List<TestQuestions> answers) {
        if (answers.isEmpty()) return null;
        return answers.get(0).getQuiz().getQuestionType();
    }
}
