package com.edusupernova.edusupernova.model;
import jakarta.persistence.*;
import lombok.Data;
import org.aspectj.weaver.ast.Test;

import java.util.List;

@Entity
@Table(name = "Unit")
@Data
public class Unit {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "exam_id", nullable = false)
    private Exams exam;

    @Column(nullable = false, length = 100)
    private String title;

    @Column(columnDefinition = "INT DEFAULT 1")
    private Integer queue = 1;
}
