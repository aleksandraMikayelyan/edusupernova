package com.edusupernova.edusupernova.service;

import com.edusupernova.edusupernova.config.JwtTokenUtil;
import com.edusupernova.edusupernova.data.UserRepository;
import com.edusupernova.edusupernova.dto.AuthResponse;
import com.edusupernova.edusupernova.dto.LoginRequest;
import com.edusupernova.edusupernova.dto.RegisterRequest;
import com.edusupernova.edusupernova.model.Role;
import com.edusupernova.edusupernova.model.Users;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * Handles user registration and authentication, returning a JWT token
 * on success.
 *
 * SRP  – only responsible for auth flows; token generation is delegated
 *        to {@link JwtTokenUtil}.
 * DIP  – constructor injection via {@code @RequiredArgsConstructor}.
 */
@Service
@RequiredArgsConstructor
@Transactional
public class UsersService {

    private final UserRepository        userRepository;
    private final PasswordEncoder       passwordEncoder;
    private final AuthenticationManager authenticationManager;
    private final JwtTokenUtil          jwtTokenUtil;

    // ── Public API ────────────────────────────────────────────────────────────

    /**
     * Registers a new user and returns a JWT token for immediate login.
     *
     * @throws IllegalArgumentException if the e-mail is already taken
     */
    public AuthResponse register(RegisterRequest request) {
        if (userRepository.findByEmail(request.email()) != null) {
            throw new IllegalArgumentException("Email already registered");
        }

        Users user = buildUser(request);
        userRepository.save(user);

        return new AuthResponse(jwtTokenUtil.generateToken(user), user.getRol().name());
    }

    /**
     * Authenticates a user by e-mail and password, returning a JWT token.
     *
     * @throws IllegalArgumentException if credentials are invalid
     */
    public AuthResponse login(LoginRequest request) {
        authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(request.email(), request.password())
        );

        Users user = userRepository.findByEmail(request.email());
        if (user == null) {
            throw new IllegalArgumentException("User not found after authentication");
        }

        return new AuthResponse(jwtTokenUtil.generateToken(user), user.getRol().name());
    }

    // ── Private helpers ───────────────────────────────────────────────────────

    private Users buildUser(RegisterRequest request) {
        Users user = new Users();
        user.setUsername(request.username());
        user.setEmail(request.email());
        user.setPassword(passwordEncoder.encode(request.password()));
        user.setRol(request.rol() != null ? request.rol() : Role.STUDENT);
        return user;
    }
}