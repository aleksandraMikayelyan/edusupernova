package com.edusupernova.edusupernova.test.service;

import com.edusupernova.edusupernova.test.dto.response.FeedBackDTO;
import com.edusupernova.edusupernova.test.dto.response.TestHistoryDTO;
import com.edusupernova.edusupernova.test.dto.response.TestQuestionDTO;
import com.edusupernova.edusupernova.test.dto.response.TestSessionDTO;
import com.edusupernova.edusupernova.model.Paper;
import com.edusupernova.edusupernova.model.Quiz;
import com.edusupernova.edusupernova.model.QuestionGroup;
import com.edusupernova.edusupernova.model.TestQuestions;
import com.edusupernova.edusupernova.model.Tests;
import com.edusupernova.edusupernova.model.Unit;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import java.time.temporal.ChronoUnit;
import java.util.List;

/**
 * Converts domain entities to DTOs. No business logic — mapping only (SRP).
 */
@Component
@RequiredArgsConstructor
public class TestMapper {

    @Value("${app.base-url:}")
    private String baseUrl;

    private final TestScoringHelper scoringHelper;

    // ── Session ───────────────────────────────────────────────────────────────

    public TestSessionDTO toSessionDTO(
            Tests test,
            List<TestQuestions> allQuestions,
            Paper paper,
            Unit unit,
            int timeLimitMinutes) {

        TestQuestionDTO currentQuestion = allQuestions.stream()
                .filter(q -> q.getUserResponse() == null || q.getUserResponse().isBlank())
                .findFirst()
                .map(q -> toQuestionDTO(q, getQuestionNumber(allQuestions, q)))
                .orElse(null);

        return new TestSessionDTO(
                test.getId(),
                test.getCourse().getCoursename(),
                paper != null ? paper.getPaperName()     : null,
                paper != null ? paper.getFormat().name() : null,
                unit  != null ? unit.getTitle()          : null,
                allQuestions.size(),
                (int) allQuestions.stream()
                        .filter(q -> q.getUserResponse() != null && !q.getUserResponse().isBlank())
                        .count(),
                test.getTotalCorrect(),
                test.getStatus().name(),
                test.getStartedAt(),
                timeLimitMinutes,
                scoringHelper.getRemainingSeconds(test),
                currentQuestion
        );
    }

    // ── Question ──────────────────────────────────────────────────────────────

    public TestQuestionDTO toQuestionDTO(TestQuestions tq, int questionNumber) {
        Quiz          quiz  = tq.getQuiz();
        QuestionGroup group = quiz.getQuestionGroup();
        return new TestQuestionDTO(
                tq.getId().getTestId(),
                quiz.getId(),
                questionNumber,
                quiz.getQuestionText(),
                quiz.getQuestionType().name(),
                quiz.getDifficulty() != null ? quiz.getDifficulty().name() : "MEDIUM",
                quiz.getOptionA(), quiz.getOptionB(), quiz.getOptionC(),
                quiz.getOptionD(), quiz.getOptionE(),
                tq.getUserResponse(),
                tq.getCorrectResponse(),
                tq.getFeedbackIa(),
                group != null ? group.getId()                               : null,
                group != null ? group.getTitle()                            : null,
                group != null ? group.getContextText()                      : null,
                group != null ? resolveImageUrl(group.getContextImageUrl()) : null,
                quiz.getGroupOrderIndex(),
                quiz.getMarks()
        );
    }

    // ── Feedback ──────────────────────────────────────────────────────────────

    public FeedBackDTO.QuestionFeedbackDTO toQuestionFeedbackDTO(TestQuestions tq, int questionNumber) {
        Quiz          quiz  = tq.getQuiz();
        QuestionGroup group = quiz.getQuestionGroup();
        return new FeedBackDTO.QuestionFeedbackDTO(
                questionNumber,
                quiz.getId(),
                quiz.getQuestionText(),
                quiz.getQuestionType().name(),
                tq.getUserResponse(),
                quiz.getCorrectAnswer(),
                tq.getCorrectResponse(),
                quiz.getExplanation(),
                tq.getFeedbackIa(),
                tq.getAiScore(),
                group != null ? resolveImageUrl(group.getContextImageUrl()) : null,
                group != null ? group.getContextText()                      : null
        );
    }

    // ── History ───────────────────────────────────────────────────────────────

    public TestHistoryDTO toHistoryDTO(Tests t) {
        long duration = t.getCompletedAt() != null && t.getStartedAt() != null
                ? ChronoUnit.SECONDS.between(t.getStartedAt(), t.getCompletedAt())
                : 0L;
        int total = t.getTotalAnswered() != null ? t.getTotalAnswered() : 0;
        return new TestHistoryDTO(
                t.getId(),
                t.getCourse() != null ? t.getCourse().getId()           : null,
                t.getCourse() != null ? t.getCourse().getCoursename()   : null,
                t.getPaper()  != null ? t.getPaper().getId()            : null,
                t.getPaper()  != null ? t.getPaper().getPaperName()     : null,
                t.getPaper()  != null ? t.getPaper().getFormat().name() : null,
                t.getFinalScore(),
                scoringHelper.calculateGrade(t.getFinalScore() != null ? t.getFinalScore() : 0.0),
                t.getTotalCorrect(),
                total,
                t.getCompletedAt(),
                duration
        );
    }

    // ── Helpers ───────────────────────────────────────────────────────────────

    public int getQuestionNumber(List<TestQuestions> all, TestQuestions target) {
        return all.indexOf(target) + 1;
    }

    /**
     * Resolves a relative image path to an absolute URL so cross-origin frontends can load it.
     * Resolution order: already absolute → BASE_URL env → current request context.
     */
    public String resolveImageUrl(String url) {
        if (url == null || url.isBlank()) return null;
        if (url.startsWith("http://") || url.startsWith("https://")) return url;
        if (!baseUrl.isBlank()) return baseUrl + url;
        try {
            return ServletUriComponentsBuilder.fromCurrentContextPath()
                    .path(url).build().toUriString();
        } catch (Exception e) {
            return url;
        }
    }
}
