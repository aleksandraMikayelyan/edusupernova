package com.edusupernova.edusupernova.model;

import jakarta.persistence.*;
import lombok.Data;
import java.util.List;

@Entity
@Table(name = "Papers")
@Data
public class Paper {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "idPaper")
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "idCourse", nullable = false)
    @com.fasterxml.jackson.annotation.JsonIgnore
    private Courses course;

    // "Paper 1", "Paper 2", "Listening", "Writing Task 2"
    @Column(nullable = false, length = 100)
    private String paperName;

    // Real instructions shown to student before starting
    @Column(columnDefinition = "TEXT")
    private String instructions;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private PaperFormat format;

    // How many questions in a real sitting
    @Column(nullable = false)
    private Integer totalQuestions;

    // Time allowed in real exam (minutes)
    @Column
    private Integer timeLimitMinutes;

    // Display order (Paper 1 before Paper 2 etc.)
    @Column(nullable = false)
    private Integer orderIndex;

    @OneToMany(mappedBy = "paper", cascade = CascadeType.ALL)
    @com.fasterxml.jackson.annotation.JsonIgnore
    private List<Quiz> questions;

    public enum PaperFormat {
        MCQ,            // A Levels Paper 1, SAT Reading
        DATA_RESPONSE,  // A Levels Paper 2
        ESSAY,          // A Levels Paper 3, IELTS Writing Task 2
        SHORT_ANSWER,   // IELTS Writing Task 1
        LISTENING,      // IELTS/TOEFL Listening (audio script)
        READING,        // IELTS Reading (passage + questions)
        SPEAKING,       // TOEFL Speaking (prompt based)
        NUMERIC_INPUT,  // SAT Math grid-in
        TRUE_FALSE_NG   // IELTS True/False/Not Given
    }
}