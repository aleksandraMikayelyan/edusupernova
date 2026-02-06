package com.edusupernova.edusupernova.model;
import jakarta.persistence.*;
import lombok.Data;
import org.aspectj.weaver.ast.Test;

import java.util.List;
@Entity
@Table(name = "Courses")
@Data
public class Courses {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "`idCourse`")
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "idExam", nullable = false)
    private Exams exam;

    @Column(nullable = false, length = 100)
    private String coursename;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(length = 100)
    private String icon;

    @Column(columnDefinition = "INT DEFAULT 0")
    private Integer totalQuestions = 0;
}