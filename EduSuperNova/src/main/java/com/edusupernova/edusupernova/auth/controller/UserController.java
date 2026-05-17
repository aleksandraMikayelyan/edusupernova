package com.edusupernova.edusupernova.auth.controller;

import com.edusupernova.edusupernova.auth.dto.request.GoogleAuthRequest;
import com.edusupernova.edusupernova.auth.dto.request.LoginRequest;
import com.edusupernova.edusupernova.auth.dto.request.RegisterRequest;
import com.edusupernova.edusupernova.auth.dto.request.VerifyEmailRequest;
import com.edusupernova.edusupernova.auth.dto.response.AuthResponse;
import com.edusupernova.edusupernova.shared.dto.response.MessageResponse;
import com.edusupernova.edusupernova.auth.service.IAuthService;
import com.edusupernova.edusupernova.auth.service.IUserRegistrationService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

/**
 * REST controller for user registration, email verification, and authentication.
 * Each dependency is a focused, single-responsibility service (ISP + DIP).
 *
 * Registration flow:
 *   1. POST /register      → 202 (code sent, no JWT yet)
 *   2. POST /verify-email  → 200 (code validated, JWT issued)
 *
 * Authentication:
 *   POST /login            → 200 (JWT issued)
 *   POST /google-auth      → 200 (JWT issued)
 */
@RestController
@RequestMapping("/api/users")
@RequiredArgsConstructor
public class UserController {

    private final IUserRegistrationService registrationService;
    private final IAuthService             authService;

    @PostMapping("/register")
    public ResponseEntity<MessageResponse> register(@Valid @RequestBody RegisterRequest request) {
        return ResponseEntity.status(HttpStatus.ACCEPTED).body(registrationService.register(request));
    }

    @PostMapping("/verify-email")
    public ResponseEntity<AuthResponse> verifyEmail(@Valid @RequestBody VerifyEmailRequest request) {
        return ResponseEntity.ok(registrationService.verifyEmail(request));
    }

    @PostMapping("/login")
    public ResponseEntity<AuthResponse> login(@RequestBody LoginRequest request) {
        return ResponseEntity.ok(authService.login(request));
    }

    @PostMapping("/google-auth")
    public ResponseEntity<AuthResponse> googleAuth(@RequestBody GoogleAuthRequest request) {
        return ResponseEntity.ok(authService.googleAuth(request));
    }
}
