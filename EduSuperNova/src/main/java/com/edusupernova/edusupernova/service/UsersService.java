package com.edusupernova.edusupernova.service;

import com.edusupernova.edusupernova.config.JwtTokenUtil;
import com.edusupernova.edusupernova.data.UserRepository;
import com.edusupernova.edusupernova.dto.AuthResponse;
import com.edusupernova.edusupernova.dto.LoginRequest;
import com.edusupernova.edusupernova.dto.RegisterRequest;
import com.edusupernova.edusupernova.model.Role;
import com.edusupernova.edusupernova.model.Users;
import jakarta.transaction.Transactional;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;


@Service
@Transactional
public class UsersService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final AuthenticationManager authenticationManager;
    private final JwtTokenUtil jwtTokenUtil; // 1. Add JwtTokenUtil

    public UsersService(UserRepository userRepository,
                        PasswordEncoder passwordEncoder,
                        AuthenticationManager authenticationManager,
                        JwtTokenUtil jwtTokenUtil) { // 2. Inject it
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
        this.authenticationManager = authenticationManager;
        this.jwtTokenUtil = jwtTokenUtil;
    }

    public AuthResponse register(RegisterRequest request) {
        // 3. Robust existence check (assuming repository returns Optional or null)
        Users existingUser = userRepository.findByEmail(request.email());
        if (existingUser != null) {
            throw new IllegalArgumentException("Email already exists");
        }

        Users user = new Users();
        user.setUsername(request.username());
        user.setEmail(request.email());
        user.setPassword(passwordEncoder.encode(request.password()));
        user.setRol(request.rol() != null ? request.rol() : Role.STUDENT);

        userRepository.save(user);

        // 4. Call via the injected instance
        String token = jwtTokenUtil.generateToken(user);
        return new AuthResponse(token);
    }

    public AuthResponse login(LoginRequest request) {
        // This validates the credentials
        authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(request.email(), request.password())
        );

        Users user = userRepository.findByEmail(request.email());
        if (user == null) {
            throw new IllegalArgumentException("User not found after authentication");
        }

        // 5. Call via the injected instance
        String token = jwtTokenUtil.generateToken(user);
        return new AuthResponse(token);
    }
}