package com.edusupernova.edusupernova.model;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.persistence.*;
import lombok.Data;
import java.util.List;

@Entity
@Table(name = "courses")
@Data
public class Courses {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "idCourse")
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "idExam", nullable = false)
    @JsonBackReference
    private Exams exam;

    @Column(nullable = false, length = 100)
    private String coursename;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(length = 100)
    private String icon;

    @Column(columnDefinition = "INT DEFAULT 0")
    private Integer totalQuestions = 0;

    @Enumerated(EnumType.STRING)
    @Column(name = "section", length = 2)
    private ALevelSection section;

    @OneToMany(mappedBy = "course", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JsonManagedReference
    private List<Unit> units;
}
