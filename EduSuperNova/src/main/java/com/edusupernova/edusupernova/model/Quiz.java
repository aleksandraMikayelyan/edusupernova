package com.edusupernova.edusupernova.model;
import jakarta.persistence.*;
import lombok.Data;
import org.aspectj.weaver.ast.Test;

import java.util.List;
@Entity
@Table(name = "Quiz")
@Data
public class Quiz {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "exam_id", nullable = false)
    private Exams exam;

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
    private List<TestQuestions> testQuestions;
}
