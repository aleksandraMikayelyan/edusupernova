package com.edusupernova.edusupernova.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.Data;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import java.time.LocalDateTime;
import java.util.List;



@Entity
@Table(name = "tests")
@Data
public class Tests {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "idTest")
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "idUser", nullable = false)
    private Users user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "idCourse", nullable = false)
    private Courses course;

    // ← Student is doing Paper 1 of this course
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "idPaper", nullable = false)
    private Paper paper;

    // ← Optionally filtered to Unit 1 only (nullable = full paper)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "idUnit", nullable = true)
    private Unit unit;

    @Column(columnDefinition = "TIMESTAMP DEFAULT CURRENT_TIMESTAMP") /* */
    private LocalDateTime creationDate = LocalDateTime.now();

    @Column
    private LocalDateTime startedAt;

    @Column
    private LocalDateTime completedAt;

    /** Time limit for this session in minutes (copied from Paper or Exam at start time). */
    @Column
    private Integer timeLimitMinutes;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private TestStatus status = TestStatus.IN_PROGRESS;

    @Column(precision = 5, scale = 2)
    @JdbcTypeCode(SqlTypes.NUMERIC)
    private Double finalScore = 0.0;

    @Column(nullable = false, columnDefinition = "INT DEFAULT 0")
    private Integer totalCorrect = 0;

    @Column(nullable = false, columnDefinition = "INT DEFAULT 0")
    private Integer totalAnswered = 0;

    @OneToMany(mappedBy = "test", cascade = CascadeType.ALL)
    @com.fasterxml.jackson.annotation.JsonIgnore
    private List<TestQuestions> testQuestions;

    public enum TestStatus { IN_PROGRESS, COMPLETED, ABANDONED }
}