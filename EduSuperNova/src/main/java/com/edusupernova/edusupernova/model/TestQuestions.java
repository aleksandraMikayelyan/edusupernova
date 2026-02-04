package com.edusupernova.edusupernova.model;
import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Data;
import lombok.Getter;
import org.aspectj.weaver.ast.Test;

import java.util.List;
@Entity
@Table(name = "Test_Question")
@Data
public class TestQuestions {
    @EmbeddedId
    private TestQuestionId id;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("idTest")
    @JoinColumn(name = "idTest")
    @Getter(value = AccessLevel.PUBLIC, onMethod_ = @Column(name = "idTest"))
    private Tests test;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("idQuiz")
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
}