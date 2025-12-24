package com.edusupernova.edusupernova.model;
import com.edusupernova.edusupernova.model.EnrollmentId;
import com.edusupernova.edusupernova.model.Exams;
import com.edusupernova.edusupernova.model.Users;
import jakarta.persistence.*;
import lombok.Data;
import org.aspectj.weaver.ast.Test;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "Enrollment")
@Data
public class Enrollment{
    @EmbeddedId
    private EnrollmentId id;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("userId")
    @JoinColumn(name = "user_id")
    private Users user;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("examId")
    @JoinColumn(name = "exam_id")
    private Exams exam;

    @Column(columnDefinition = "DATETIME DEFAULT CURRENT_TIMESTAMP")
    private LocalDateTime enrolledAt = LocalDateTime.now();

    @Column(precision = 5, scale = 2, columnDefinition = "DECIMAL(5,2) DEFAULT 0.00")
    private BigDecimal progress = BigDecimal.ZERO;

    private LocalDateTime lastActivity;
}

