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

    public UsersService(UserRepository userRepository, PasswordEncoder passwordEncoder, AuthenticationManager authenticationManager) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
        this.authenticationManager = authenticationManager;
    }

    public AuthResponse register(RegisterRequest request) {
        // Corrección: verificar si ya existe
        if (userRepository.findByEmail(request.email()).isEnabled()) {
            throw new IllegalArgumentException("Email already exists");
        }

        Users user = new Users();
        user.setUsername(request.username());
        user.setEmail(request.email());
        user.setPassword(passwordEncoder.encode(request.password()));
        user.setRol(request.rol() != null ? request.rol() : Role.STUDENT);

        userRepository.save(user);

        // Ahora funcionará porque Users implementará UserDetails
        String token = JwtTokenUtil.generateToken(user);
        return new AuthResponse(token);
    }

    public AuthResponse login(LoginRequest request) {
        authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(request.email(), request.password())
        );

        // Corrección: manejar el Optional
        Users user = userRepository.findByEmail(request.email());

        String token = JwtTokenUtil.generateToken(user);
        return new AuthResponse(token);
    }
}