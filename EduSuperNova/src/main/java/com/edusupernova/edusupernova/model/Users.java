package com.edusupernova.edusupernova.model;


import jakarta.persistence.*;
import lombok.Data;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.Collection;
import java.util.List;

@Entity
@Table(name = "users")
@Data
public class Users implements UserDetails { // 1. Implementa la interfaz

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

    // --- MÉTODOS DE USERDETAILS ---

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        // Convierte tu ENUM de rol en una autoridad que Spring entienda
        return List.of(new SimpleGrantedAuthority("ROLE_" + rol.name()));
    }

    @Override
    public String getUsername() {
        // IMPORTANTE: Spring Security usa este método para identificar al usuario.
        // Si haces login con email, devuelve el email aquí.
        return this.email;
    }

    @Override
    public boolean isAccountNonExpired() {
        return true; // Cambiar a lógica real si manejas expiración
    }

    @Override
    public boolean isAccountNonLocked() {
        return true; // Cambiar a lógica real si manejas bloqueos
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        return Boolean.TRUE.equals(emailVerified);
    }
}