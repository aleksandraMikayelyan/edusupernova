package com.edusupernova.edusupernova.controller;

import com.edusupernova.edusupernova.dto.request.GoogleAuthRequest;
import com.edusupernova.edusupernova.dto.request.LoginRequest;
import com.edusupernova.edusupernova.dto.request.RegisterRequest;
import com.edusupernova.edusupernova.dto.response.AuthResponse;
import com.edusupernova.edusupernova.dto.response.MessageResponse;
import com.edusupernova.edusupernova.service.UsersService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

/**
 * REST controller for user registration, email verification, and authentication.
 *
 * SRP: this class handles HTTP mapping only. All business logic lives in
 *      {@link UsersService}; all exception-to-response translation lives in
 *      {@code GlobalExceptionHandler}.
 *
 * Registration flow:
 *   1. POST /register        → 202  (code sent, no JWT yet)
 *   2. POST /verify-email    → 200  (code validated, JWT issued)
 *
 * Direct login (already-verified accounts):
 *   POST /login              → 200  (JWT issued)
 *
 * Google OAuth (email pre-verified by Google):
 *   POST /google-auth        → 200  (JWT issued)
 */
@RestController
@RequestMapping("/api/users")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class UserController {

    private final UsersService usersService;

    /**
     * Step 1 of registration: creates the account and sends a verification code.
     * Returns 202 Accepted because the process is not yet complete — the user
     * must still confirm their email.
     */
    @PostMapping("/register")
    public ResponseEntity<MessageResponse> register(@Valid @RequestBody RegisterRequest request) {
        MessageResponse response = usersService.register(request);
        return ResponseEntity.status(HttpStatus.ACCEPTED).body(response);
    }

    /**
     * Authenticates an already-verified user with email + password.
     * Unverified accounts are rejected automatically by Spring Security
     * ({@code isEnabled()} returns false) before reaching this handler.
     */
    @PostMapping("/login")
    public ResponseEntity<AuthResponse> login(@RequestBody LoginRequest request) {
        return ResponseEntity.ok(usersService.login(request));
    }

    /**
     * Authenticates (or auto-registers) a user via a Google ID token.
     * Google accounts are always treated as verified.
     */
    @PostMapping("/google-auth")
    public ResponseEntity<AuthResponse> googleAuth(@RequestBody GoogleAuthRequest request) {
        return ResponseEntity.ok(usersService.googleAuth(request));
    }
}
