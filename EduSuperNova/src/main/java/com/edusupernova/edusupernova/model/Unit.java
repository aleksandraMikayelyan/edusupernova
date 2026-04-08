package com.edusupernova.edusupernova.model;

import com.fasterxml.jackson.annotation.JsonBackReference;
import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table(name = "Units")
@Data
public class Unit {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "idUnit")
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "idCourse", nullable = false)
    @JsonBackReference
    private Courses course;

    @Column(nullable = false, length = 100)
    private String title;

    /**
     * Filesystem path to the unit's markdown summary file.
     * UnitService reads this at request time and returns the content in a DTO —
     * the entity itself only ever holds the path.
     */
    @Column(name = "summary_path", nullable = false, length = 255)
    private String summaryPath;

    @Column(columnDefinition = "INT DEFAULT 1")
    private Integer queue = 1;
}