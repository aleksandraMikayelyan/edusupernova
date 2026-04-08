package com.edusupernova.edusupernova.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table(name = "Test_Question")
@Data
public class TestQuestions {

    @EmbeddedId
    private TestQuestionId id;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("testId")
    @JoinColumn(name = "idTest")
    @JsonIgnore
    private Tests test;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("quizId")
    @JoinColumn(name = "idQuiz")
    private Quiz quiz;

    @Column(columnDefinition = "TEXT")
    private String userResponse;

    @Column(columnDefinition = "BOOLEAN DEFAULT FALSE")
    private Boolean correctResponse = false;

    @Column(columnDefinition = "INT DEFAULT 0")
    private Integer punctuation = 0;

    @Column(columnDefinition = "TEXT")
    private String feedbackIa;

    /** AI score (0-10) for open-ended questions; null for MCQ. */
    @Column
    private Double aiScore;

    @Column
    private java.time.LocalDateTime answeredAt;
}