package com.edusupernova.edusupernova.auth.service;

import com.edusupernova.edusupernova.config.JwtTokenUtil;
import com.edusupernova.edusupernova.config.UserPrincipal;
import com.edusupernova.edusupernova.data.UserRepository;
import com.edusupernova.edusupernova.auth.dto.request.GoogleAuthRequest;
import com.edusupernova.edusupernova.auth.dto.request.LoginRequest;
import com.edusupernova.edusupernova.auth.dto.response.AuthResponse;
import com.edusupernova.edusupernova.auth.dto.response.UserSummaryDTO;
import com.edusupernova.edusupernova.exception.BusinessRuleException;
import com.edusupernova.edusupernova.model.Role;
import com.edusupernova.edusupernova.model.Users;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.gson.GsonFactory;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collections;
import java.util.UUID;

/**
 * Handles credential-based login and OAuth authentication flows.
 * Registration and email verification live in {@link UserRegistrationService}.
 */
@Service
@RequiredArgsConstructor
@Transactional
public class AuthService implements IAuthService {

    private final UserRepository        userRepository;
    private final AuthenticationManager authenticationManager;
    private final JwtTokenUtil          jwtTokenUtil;
    private final PasswordEncoder       passwordEncoder;

    @Value("${google.oauth2.client-id}")
    private String googleClientId;

    @Override
    public AuthResponse login(LoginRequest request) {
        authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(request.email(), request.password())
        );
        Users user = userRepository.findByEmail(request.email());
        if (user == null) throw new IllegalArgumentException("User not found after authentication");
        return buildAuthResponse(user);
    }

    @Override
    public AuthResponse googleAuth(GoogleAuthRequest request) {
        GoogleIdToken.Payload payload = verifyGoogleToken(request.idToken());

        String email = payload.getEmail();
        String name  = (String) payload.get("name");
        if (name == null || name.isBlank()) name = email.split("@")[0];

        Users user = userRepository.findByEmail(email);
        if (user == null) {
            user = buildGoogleUser(email, name);
            userRepository.save(user);
        }
        return buildAuthResponse(user);
    }

    // ── Private helpers ───────────────────────────────────────────────────────

    private Users buildGoogleUser(String email, String name) {
        Users user = new Users();
        user.setUsername(name);
        user.setEmail(email);
        // Unusable placeholder — normal password login cannot be used for Google accounts
        user.setPassword(passwordEncoder.encode(UUID.randomUUID().toString()));
        user.setRol(Role.STUDENT);
        user.setEmailVerified(true);
        return user;
    }

    private AuthResponse buildAuthResponse(Users user) {
        String token     = jwtTokenUtil.generateToken(new UserPrincipal(user));
        long   expiresIn = jwtTokenUtil.getExpirationMs() / 1000;
        UserSummaryDTO summary = new UserSummaryDTO(
                user.getId(), user.getUsername(), user.getEmail(), user.getRol().name());
        return new AuthResponse(token, "Bearer", expiresIn, user.getRol().name(), summary);
    }

    private GoogleIdToken.Payload verifyGoogleToken(String idTokenString) {
        try {
            GoogleIdTokenVerifier verifier = new GoogleIdTokenVerifier.Builder(
                    new NetHttpTransport(), GsonFactory.getDefaultInstance())
                    .setAudience(Collections.singletonList(googleClientId))
                    .build();
            GoogleIdToken idToken = verifier.verify(idTokenString);
            if (idToken == null) throw new BusinessRuleException("Invalid Google ID token");
            return idToken.getPayload();
        } catch (BusinessRuleException e) {
            throw e;
        } catch (Exception e) {
            throw new BusinessRuleException("Could not verify Google token: " + e.getMessage());
        }
    }
}
