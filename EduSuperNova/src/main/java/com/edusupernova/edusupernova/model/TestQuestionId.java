package com.edusupernova.edusupernova.model;

import jakarta.persistence.Embeddable;
import lombok.Data;

import java.io.Serializable;

@Embeddable
@Data
public class TestQuestionId implements Serializable {
    private Integer idTest;
    private Integer idQuiz;
}
