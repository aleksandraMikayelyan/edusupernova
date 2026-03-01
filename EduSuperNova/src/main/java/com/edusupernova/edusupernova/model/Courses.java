package com.edusupernova.edusupernova.model;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonManagedReference; // Añade esta
import jakarta.persistence.*;
import lombok.Data;
import java.util.List;

@Entity
@Table(name = "Courses")
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

    // --- ESTO ES LO QUE FALTA ---
    // mappedBy debe coincidir con el nombre del campo en la clase Unit (que es "course")
    @OneToMany(mappedBy = "course", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JsonManagedReference
    private List<Unit> units;
}