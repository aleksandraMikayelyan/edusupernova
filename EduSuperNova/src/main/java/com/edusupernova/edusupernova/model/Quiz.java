package com.edusupernova.edusupernova.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.Data;

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
    @JsonIgnore
    private Courses course;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "idPaper", nullable = true)
    @JsonIgnore
    private Paper paper;

    /** Optional topic tag — lets "Paper 1 from Unit 3 only" filtering work. */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "idUnit", nullable = true)
    @JsonIgnore
    private Unit unit;

    @Column(columnDefinition = "TEXT", nullable = false)
    private String questionText;

    // Answer options — nullable because not all question types use them.
    // MCQ → A/B/C/D (or A-E for ACT Math). TRUE_FALSE_NG → A/B/C represent T/F/NG.
    @Column(columnDefinition = "TEXT") private String optionA;
    @Column(columnDefinition = "TEXT") private String optionB;
    @Column(columnDefinition = "TEXT") private String optionC;
    @Column(columnDefinition = "TEXT") private String optionD;
    @Column(columnDefinition = "TEXT") private String optionE;

    /**
     * The correct answer, format depends on questionType:
     *   MULTIPLE_CHOICE → "A" / "B" / "C" / "D" / "E"
     *   TRUE_FALSE_NG   → "TRUE" / "FALSE" / "NOT_GIVEN"
     *   NUMERIC_INPUT   → "42" / "3.14"
     *   SHORT_ANSWER    → model answer (Groq compares loosely)
     *   ESSAY           → rubric / model answer (Groq scores against it)
     *   OPEN_ENDED      → model answer (Groq)
     */
    @Column(columnDefinition = "TEXT", nullable = false)
    private String correctAnswer;

    /** Static explanation shown in the report after submission. */
    @Column(columnDefinition = "TEXT")
    private String explanation;

    /** Optional per-question override for the Groq prompt. */
    @Column(columnDefinition = "TEXT")
    private String promptIa;

    /** How this question is scored (see QuestionType javadoc). */
    @Enumerated(EnumType.STRING)
    @Column(nullable = false, name = "question_type")
    private QuestionType questionType;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Difficulty difficulty = Difficulty.MEDIUM;

    @OneToMany(mappedBy = "quiz", cascade = CascadeType.ALL)
    @JsonIgnore
    private List<TestQuestions> testQuestions;

    public enum Difficulty { EASY, MEDIUM, HARD }

    /**
     * How a question is scored. Independent of Paper.PaperFormat:
     * a single IELTS Reading paper can contain MULTIPLE_CHOICE, TRUE_FALSE_NG,
     * and SHORT_ANSWER questions all at once.
     *
     * Synchronous scoring (no AI): MULTIPLE_CHOICE, TRUE_FALSE_NG, NUMERIC_INPUT
     * Async Groq scoring:          SHORT_ANSWER, ESSAY, OPEN_ENDED
     */
    public enum QuestionType {
        MULTIPLE_CHOICE,
        TRUE_FALSE_NG,
        NUMERIC_INPUT,
        SHORT_ANSWER,
        ESSAY,
        OPEN_ENDED
    }
}