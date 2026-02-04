package com.edusupernova.edusupernova.model;

import jakarta.persistence.Embeddable;
import lombok.Data;

import java.io.Serializable;


@Embeddable
@Data
public class EnrollmentId implements Serializable {
    private Integer userId;
    private Integer examId;

    // Constructor vacío obligatorio para JPA
    public EnrollmentId() {}

    // Constructor con parámetros que necesitas
    public EnrollmentId(Integer userId, Integer examId) {
        this.userId = userId;
        this.examId = examId;
    }
}

