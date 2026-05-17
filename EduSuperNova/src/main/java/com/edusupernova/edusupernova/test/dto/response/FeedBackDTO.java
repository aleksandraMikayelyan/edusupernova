package com.edusupernova.edusupernova.test.dto.response;

import java.time.LocalDateTime;
import java.util.List;

/**
 * GET /tests/{testId}/report
 *
 * Full post-test report shown on the Feedback page.
 * Replaces the old FeedBackDTO — now uses records for immutability.
 */
public record FeedBackDTO(
        Integer testId,
        String courseName,
        String paperName,
        String unitName,            // null if full paper

        // Score summary
        Integer totalCorrect,
        Integer totalQuestions,
        Double finalScore,          // percentage 0-100
        String grade,               // "A", "B", "C" etc. — calculated by service

        // Timing
        LocalDateTime startedAt,
        LocalDateTime completedAt,
        Long durationSeconds,

        // Per-question breakdown
        List<QuestionFeedbackDTO> questionsFeedback
) {

    /**
     * Individual question result shown in the report.
     * contextImageUrl and contextText are non-null for grouped questions (e.g. IELTS Writing Task 1)
     * so the student can see the visual they were asked to describe when reviewing their attempt.
     */
    public record QuestionFeedbackDTO(
            Integer questionNumber,
            Integer quizId,
            String questionText,
            String type,            // MCQ, ESSAY, etc.
            String userResponse,    // what the student answered
            String correctAnswer,   // the right answer
            Boolean isCorrect,
            String explanation,     // static DB explanation
            String aiFeedback,      // Groq-generated feedback
            Double aiScore,         // 0-10 for essays, null for MCQ
            String contextImageUrl, // chart/diagram shown with the question (null for standalone MCQ)
            String contextText      // passage/description shown with the question (null for standalone MCQ)
    ) {}
}