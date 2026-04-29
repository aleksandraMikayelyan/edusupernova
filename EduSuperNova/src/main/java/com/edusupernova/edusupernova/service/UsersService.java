package com.edusupernova.edusupernova.service;

import com.edusupernova.edusupernova.config.JwtTokenUtil;
import com.edusupernova.edusupernova.data.UserRepository;
import com.edusupernova.edusupernova.dto.request.GoogleAuthRequest;
import com.edusupernova.edusupernova.dto.request.LoginRequest;
import com.edusupernova.edusupernova.dto.request.RegisterRequest;
import com.edusupernova.edusupernova.dto.request.VerifyEmailRequest;
import com.edusupernova.edusupernova.dto.response.AuthResponse;
import com.edusupernova.edusupernova.dto.response.MessageResponse;
import com.edusupernova.edusupernova.dto.response.UserSummaryDTO;
import com.edusupernova.edusupernova.exception.BusinessRuleException;
import com.edusupernova.edusupernova.exception.ResourceNotFoundException;
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
 * Handles user registration, email verification, and authentication.
 *
 * SRP: delegates email-code logic to {@link EmailVerificationService}, JWT
 *      creation to {@link JwtTokenUtil}, and persistence to {@link UserRepository}.
 *      This class orchestrates the auth flows only.
 *
 * DIP: depends on {@link EmailVerificationService} as an interface, not on its
 *      concrete implementation.
 *
 * Security notes:
 *   - Every new account starts with emailVerified=false. A JWT is only issued
 *     after the user proves ownership of the address via a 6-digit code.
 *   - Google OAuth accounts bypass code verification because Google has already
 *     confirmed the address.
 *   - The rol field is never read from the request body — all registrations are
 *     STUDENT. Promotion to ADMIN requires a direct DB operation.
 */
@Service
@RequiredArgsConstructor
@Transactional
public class UsersService {

    private final UserRepository          userRepository;
    private final PasswordEncoder         passwordEncoder;
    private final AuthenticationManager   authenticationManager;
    private final JwtTokenUtil            jwtTokenUtil;
    private final EmailVerificationService emailVerificationService;

    @Value("${google.oauth2.client-id}")
    private String googleClientId;

    // ── Public API ────────────────────────────────────────────────────────────

    /**
     * Creates a new STUDENT account and sends a 6-digit verification code.
     *
     * Does NOT return a JWT — the account is inactive until the code is confirmed
     * via {@link #verifyEmail(VerifyEmailRequest)}.
     *
     * @throws BusinessRuleException if the email is already registered
     */
    public MessageResponse register(RegisterRequest request) {
        if (userRepository.findByEmail(request.email()) != null) {
            throw new BusinessRuleException("Email already registered");
        }

        Users user = buildUser(request);
        userRepository.save(user);

        emailVerificationService.sendCode(request.email());

        return new MessageResponse(
                "Account created. A 6-digit verification code has been sent to " +
                request.email() + ". Please enter it to activate your account.");
    }

    /**
     * Validates the 6-digit code, marks the account as verified, and returns a JWT.
     *
     * @throws ResourceNotFoundException if no account exists for the given email
     * @throws BusinessRuleException     if the code is wrong or expired
     */
    public AuthResponse verifyEmail(VerifyEmailRequest request) {
        Users user = userRepository.findByEmail(request.email());
        if (user == null) {
            throw new ResourceNotFoundException("No account found for email: " + request.email());
        }
        if (Boolean.TRUE.equals(user.getEmailVerified())) {
            throw new BusinessRuleException("Email is already verified. Please log in.");
        }

        emailVerificationService.verifyCode(request.email(), request.code());

        user.setEmailVerified(true);
        userRepository.save(user);

        return buildAuthResponse(user);
    }

    /**
     * Authenticates a user by email and password and returns a JWT.
     *
     * Spring Security's {@code isEnabled()} check (backed by {@code emailVerified})
     * will reject unverified accounts with {@code DisabledException} before this
     * method body is reached.
     *
     * @throws org.springframework.security.authentication.DisabledException
     *         if the account has not been email-verified (handled globally)
     * @throws org.springframework.security.authentication.BadCredentialsException
     *         if credentials are wrong
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

    /**
     * Verifies a Google ID token and either logs in the existing user or
     * auto-registers a new STUDENT account.
     *
     * Google accounts are created with emailVerified=true — Google has already
     * confirmed the address, so no additional code is needed.
     *
     * @throws BusinessRuleException if the token is invalid or cannot be verified
     */
    public AuthResponse googleAuth(GoogleAuthRequest request) {
        GoogleIdToken.Payload payload = verifyGoogleToken(request.idToken());

        String email = payload.getEmail();
        String name  = (String) payload.get("name");
        if (name == null || name.isBlank()) {
            name = email.split("@")[0];
        }

        Users user = userRepository.findByEmail(email);
        if (user == null) {
            user = buildGoogleUser(email, name);
            userRepository.save(user);
        }

        return buildAuthResponse(user);
    }

    // ── Private helpers ───────────────────────────────────────────────────────

    private Users buildUser(RegisterRequest request) {
        Users user = new Users();
        user.setUsername(request.username());
        user.setEmail(request.email());
        user.setPassword(passwordEncoder.encode(request.password()));
        user.setRol(Role.STUDENT);
        user.setEmailVerified(false);
        return user;
    }

    private Users buildGoogleUser(String email, String name) {
        Users user = new Users();
        user.setUsername(name);
        user.setEmail(email);
        // Unusable placeholder — BCrypt never produces this format, so the normal
        // password-login flow cannot be used for Google accounts.
        user.setPassword(passwordEncoder.encode(UUID.randomUUID().toString()));
        user.setRol(Role.STUDENT);
        // Google already verified the email address on their end
        user.setEmailVerified(true);
        return user;
    }

    private AuthResponse buildAuthResponse(Users user) {
        String token     = jwtTokenUtil.generateToken(user);
        long   expiresIn = jwtTokenUtil.getExpirationMs() / 1000;

        UserSummaryDTO summary = new UserSummaryDTO(
                user.getId(),
                user.getUsername(),
                user.getEmail(),
                user.getRol().name()
        );

        return new AuthResponse(token, "Bearer", expiresIn, user.getRol().name(), summary);
    }

    private GoogleIdToken.Payload verifyGoogleToken(String idTokenString) {
        try {
            GoogleIdTokenVerifier verifier = new GoogleIdTokenVerifier.Builder(
                    new NetHttpTransport(), GsonFactory.getDefaultInstance())
                    .setAudience(Collections.singletonList(googleClientId))
                    .build();

            GoogleIdToken idToken = verifier.verify(idTokenString);
            if (idToken == null) {
                throw new BusinessRuleException("Invalid Google ID token");
            }
            return idToken.getPayload();
        } catch (BusinessRuleException e) {
            throw e;
        } catch (Exception e) {
            throw new BusinessRuleException("Could not verify Google token: " + e.getMessage());
        }
    }
}
