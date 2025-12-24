package com.edusupernova.edusupernova.model;

import com.edusupernova.edusupernova.model.Role;
import jakarta.persistence.*;
import lombok.Data;
import org.aspectj.weaver.ast.Test;

import java.util.List;

@Entity
@Table(name = "Users")
@Data
public class Users{
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(nullable = false, length = 50)
    private String username;

    @Column(nullable = false, unique = true, length = 150)
    private String email;

    @Column(nullable = false, length = 255)
    private String password;

    @Column(nullable = false, length = 255)
    private String salt;

    @Enumerated(EnumType.STRING)
    @Column(columnDefinition = "ENUM('student', 'admin') DEFAULT 'student'")
    private Role rol = Role.STUDENT;

    // Relaciones (bidireccionales donde aplica)
    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL)
    private List<Enrollment> enrollments;

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL)
    private List<Test> tests;
}