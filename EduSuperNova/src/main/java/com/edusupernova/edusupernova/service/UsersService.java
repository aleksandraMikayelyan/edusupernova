package com.edusupernova.edusupernova.service;

import com.edusupernova.edusupernova.data.UserRepository;
import com.edusupernova.edusupernova.model.Role;
import com.edusupernova.edusupernova.model.Users;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
@Transactional
public class UsersService {

    @Autowired
    private UserRepository userRepo;

    // Utilidad para hashear contraseña con salt (recomendado BCrypt, no SHA simple)
    @Autowired
    private PasswordEncoder passwordEncoder;  // Inyecta BCryptPasswordEncoder

    // 1. Registro de usuario con salt automático (BCrypt lo incluye)
    public Users register(Users user) {
        if (userRepo.existsByEmail(user.getEmail())) {
            throw new RuntimeException("Email already registered");
        }
        if (userRepo.existsByUsername(user.getUsername())) {
            throw new RuntimeException("Username already exists");
        }

        // Con BCrypt: NO necesitas almacenar salt por separado
        // BCrypt genera y guarda el salt dentro del hash
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        // Si insistes en salt manual, genera uno y hashea, pero BCrypt es mejor

        user.setRol(Role.STUDENT); // por defecto
        return userRepo.save(user);
    }

    // 2. Obtener usuario por email (para login)
    public Users findByEmail(String email) {
        return userRepo.findByEmail(email);
    }

    // 3. Validar contraseña en login (con BCrypt)
    public boolean validatePassword(String plainPassword, String hashedPassword) {
        return passwordEncoder.matches(plainPassword, hashedPassword);
    }

    // 4. Cambiar contraseña
    public boolean updatePassword(int userId, String newPlainPassword) {
        Users user = userRepo.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
        user.setPassword(passwordEncoder.encode(newPlainPassword));
        userRepo.save(user);
        return true;
    }

    // 5. Buscar por ID
    public Users findById(int id) {
        return userRepo.findById(id).orElse(null);
    }
}