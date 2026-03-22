package com.edusupernova.edusupernova.controller;

import com.edusupernova.edusupernova.dto.AuthResponse;
import com.edusupernova.edusupernova.dto.LoginRequest;
import com.edusupernova.edusupernova.dto.RegisterRequest;
import com.edusupernova.edusupernova.service.UsersService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

/**
 * REST controller for user registration and authentication.
 *
 * SRP – delegates all auth logic to {@link UsersService};
 *       this class only handles HTTP mapping.
 */
@RestController
@RequestMapping("/api/users")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class UserController {

    private final UsersService usersService;

    @PostMapping("/register")
    public ResponseEntity<AuthResponse> register(@RequestBody RegisterRequest request) {
        return ResponseEntity.ok(usersService.register(request));
    }

    @PostMapping("/login")
    public ResponseEntity<AuthResponse> login(@RequestBody LoginRequest request) {
        return ResponseEntity.ok(usersService.login(request));
    }
}