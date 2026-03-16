package com.edusupernova.edusupernova.model;

import jakarta.persistence.*;
import lombok.Data;
import org.aspectj.weaver.ast.Test;

import java.util.List;

@Entity
@Table(name = "Quizes")
@Data
public class Quiz {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "idQuiz")
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "idCourse", nullable = false)
    @com.fasterxml.jackson.annotation.JsonIgnore
    private Courses course;

    @Column(columnDefinition = "TEXT", nullable = false)
    private String questionText;

    @Column(columnDefinition = "TEXT")
    private String options; // Podrías usar JSON si lo prefieres

    @Column(columnDefinition = "TEXT")
    private String correctAnswer;

    @Column(columnDefinition = "TEXT")
    private String promptIa;

    // Relación con TestQuestion
    @OneToMany(mappedBy = "quiz", cascade = CascadeType.ALL)
    @com.fasterxml.jackson.annotation.JsonIgnore
    private List<TestQuestions> testQuestions;
    // ← Campo que faltaba
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private QuestionType type = QuestionType.MULTIPLE_CHOICE; // valor por defecto

    // Enum interno (puedes moverlo a otro archivo si prefieres)
    public enum QuestionType {
        MULTIPLE_CHOICE,
        OPEN_ENDED,
        LOGICAL_PROBLEMS
    }
}
