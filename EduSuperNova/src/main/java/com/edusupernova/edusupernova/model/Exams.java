package com.edusupernova.edusupernova.model;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.persistence.*;
import lombok.Data;
import org.aspectj.weaver.ast.Test;

import java.util.List;

@Entity
@Table(name = "Exams")
@Data
public class Exams {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "idExam")
    private Integer id;

    @Column(nullable = false, length = 100)
    private String examname;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(length = 100)
    private String icon;

    @Column(columnDefinition = "BOOLEAN DEFAULT TRUE")
    private Boolean isActive = true;

    // Relaciones
    @OneToMany(mappedBy = "exam", cascade = CascadeType.ALL)
    @JsonManagedReference
    private List<Courses> courses;

    @OneToMany(mappedBy = "exam", cascade = CascadeType.ALL)
    @JsonIgnore
    private List<Enrollment> enrollments;
/*
    @OneToMany(mappedBy = "exam", cascade = CascadeType.ALL)
    private List<Unit> units;

    @OneToMany(mappedBy = "exam", cascade = CascadeType.ALL)
    private List<Quiz> quizzes;

    @OneToMany(mappedBy = "exam", cascade = CascadeType.ALL)
    private List<Tests> tests;*/
}
