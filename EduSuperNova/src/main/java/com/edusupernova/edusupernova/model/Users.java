package com.edusupernova.edusupernova.model;


import jakarta.persistence.*;
import lombok.Data;

import java.util.List;

@Entity
@Table(name = "users")
@Data
public class Users {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "idUser")
    private Integer id;

    @Column(nullable = false, length = 50)
    private String username;

    @Column(nullable = false, unique = true, length = 150)
    private String email;

    @Column(nullable = false, length = 255)
    private String password;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Role rol = Role.STUDENT;

    /**
     * How this account authenticates. GOOGLE accounts have an unusable random
     * password hash (see AuthService.buildGoogleUser) — never show them a
     * "current password is incorrect" error, since they never set one.
     */
    @Enumerated(EnumType.STRING)
    @Column(name = "auth_provider", nullable = false)
    private AuthProvider authProvider = AuthProvider.LOCAL;

    /**
     * False until the user confirms the 6-digit code we send on registration.
     * Spring Security's isEnabled() returns this value, so unverified users
     * are rejected at the authentication layer before any JWT is issued.
     */
    @Column(name = "emailVerified", nullable = true)
    private Boolean emailVerified = false;

    @Column(name = "verification_code", length = 6)
    private String verificationCode;

    @Column(name = "verification_code_expiry")
    private java.time.Instant verificationCodeExpiry;

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL)
    private List<Enrollment> enrollments;

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL)
    private List<Tests> tests;

}