package com.edusupernova.edusupernova.controller;

import com.edusupernova.edusupernova.dto.AuthResponse;
import com.edusupernova.edusupernova.dto.LoginRequest;
import com.edusupernova.edusupernova.dto.RegisterRequest;
import com.edusupernova.edusupernova.service.UsersService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/users")
@CrossOrigin(origins = "*")
public class UserController {
    private final UsersService usersService;

    public UserController(UsersService usersService ) {
        this.usersService = usersService;
    }

    @PostMapping("/register")
    public ResponseEntity<AuthResponse> register(@RequestBody RegisterRequest request) {
        return ResponseEntity.ok(usersService.register(request));
    }

    @PostMapping("/login")
    public ResponseEntity<AuthResponse> login(@RequestBody LoginRequest request) {
        return ResponseEntity.ok(usersService.login(request));
    }
}
