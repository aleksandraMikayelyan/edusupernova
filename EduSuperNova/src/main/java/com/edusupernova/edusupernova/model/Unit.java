package com.edusupernova.edusupernova.model;
import com.fasterxml.jackson.annotation.JsonBackReference;
import jakarta.persistence.*;
import lombok.Data;
import org.aspectj.weaver.ast.Test;

import java.util.List;

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

    @Column(nullable = false, length = 100)
    private String summary_path;

    @Column(columnDefinition = "INT DEFAULT 1")
    private Integer queue = 1;
}
