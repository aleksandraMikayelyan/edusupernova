package com.edusupernova.edusupernova.service;

import com.edusupernova.edusupernova.config.JwtTokenUtil;
import com.edusupernova.edusupernova.data.UserRepository;
import com.edusupernova.edusupernova.dto.request.LoginRequest;
import com.edusupernova.edusupernova.dto.request.RegisterRequest;
import com.edusupernova.edusupernova.dto.response.AuthResponse;
import com.edusupernova.edusupernova.dto.response.UserSummaryDTO;
import com.edusupernova.edusupernova.model.Role;
import com.edusupernova.edusupernova.model.Users;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * Handles user registration and authentication, returning a JWT token on success.
 *
 * CHANGES FROM ORIGINAL:
 *   - RegisterRequest no longer accepts a `rol` field — every new user is
 *     STUDENT by default. Admins are promoted via SQL/admin panel only.
 *     This closes a security hole where anyone could self-register as ADMIN.
 *   - AuthResponse now includes a UserSummaryDTO with basic profile info.
 *   - DTO imports updated to new request/response package structure.
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
     * Registers a new user as STUDENT and returns a JWT token for immediate login.
     *
     * @throws IllegalArgumentException if the e-mail is already taken
     */
    public AuthResponse register(RegisterRequest request) {
        if (userRepository.findByEmail(request.email()) != null) {
            throw new IllegalArgumentException("Email already registered");
        }

        Users user = buildUser(request);
        userRepository.save(user);

        return buildAuthResponse(user);
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

        return buildAuthResponse(user);
    }

    // ── Private helpers ───────────────────────────────────────────────────────

    private Users buildUser(RegisterRequest request) {
        Users user = new Users();
        user.setUsername(request.username());
        user.setEmail(request.email());
        user.setPassword(passwordEncoder.encode(request.password()));
        // ← SECURITY FIX: rol is NEVER taken from the request body
        //   Every new registration is always STUDENT.
        //   To promote to ADMIN use: UPDATE users SET rol='ADMIN' WHERE email='...';
        user.setRol(Role.STUDENT);
        return user;
    }

    private AuthResponse buildAuthResponse(Users user) {
        String token = jwtTokenUtil.generateToken(user);
        long expiresIn = jwtTokenUtil.getExpirationMs() / 1000; // convert to seconds

        UserSummaryDTO summary = new UserSummaryDTO(
                user.getId(),
                user.getUsername(),
                user.getEmail(),
                user.getRol().name()
        );

        return new AuthResponse(token, "Bearer", expiresIn, user.getRol().name(), summary);
    }
}