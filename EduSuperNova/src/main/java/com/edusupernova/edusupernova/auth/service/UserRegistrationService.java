package com.edusupernova.edusupernova.auth.service;

import com.edusupernova.edusupernova.config.JwtTokenUtil;
import com.edusupernova.edusupernova.config.UserPrincipal;
import com.edusupernova.edusupernova.data.UserRepository;
import com.edusupernova.edusupernova.auth.dto.request.RegisterRequest;
import com.edusupernova.edusupernova.auth.dto.request.VerifyEmailRequest;
import com.edusupernova.edusupernova.auth.dto.response.AuthResponse;
import com.edusupernova.edusupernova.shared.dto.response.MessageResponse;
import com.edusupernova.edusupernova.auth.dto.response.UserSummaryDTO;
import com.edusupernova.edusupernova.exception.BusinessRuleException;
import com.edusupernova.edusupernova.model.Role;
import com.edusupernova.edusupernova.model.Users;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * Handles new account creation and email verification.
 * Authentication flows (login, Google OAuth) live in {@link AuthService}.
 */
@Service
@RequiredArgsConstructor
@Transactional
public class UserRegistrationService implements IUserRegistrationService {

    private final UserRepository           userRepository;
    private final PasswordEncoder          passwordEncoder;
    private final JwtTokenUtil             jwtTokenUtil;
    private final EmailVerificationService emailVerificationService;

    @Override
    public MessageResponse register(RegisterRequest request) {
        Users existing = userRepository.findByEmail(request.email());
        if (existing != null) {
            if (Boolean.TRUE.equals(existing.getEmailVerified())) {
                throw new BusinessRuleException("Email already registered");
            }
            // Account exists but was never verified — resend the code
            emailVerificationService.sendCode(request.email());
            return new MessageResponse("Verification code sent to " + request.email());
        }
        Users user = buildUser(request);
        userRepository.save(user);
        emailVerificationService.sendCode(request.email());
        return new MessageResponse("Verification code sent to " + request.email());
    }

    @Override
    public AuthResponse verifyEmail(VerifyEmailRequest request) {
        Users user = userRepository.findByEmail(request.email());
        if (user == null) throw new BusinessRuleException("No account found for that email address");

        boolean valid = emailVerificationService.validateCode(request.email(), request.code());
        if (!valid) throw new BusinessRuleException("Invalid or expired verification code");

        user.setEmailVerified(true);
        userRepository.save(user);
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

    private AuthResponse buildAuthResponse(Users user) {
        String token     = jwtTokenUtil.generateToken(new UserPrincipal(user));
        long   expiresIn = jwtTokenUtil.getExpirationMs() / 1000;
        UserSummaryDTO summary = new UserSummaryDTO(
                user.getId(), user.getUsername(), user.getEmail(), user.getRol().name());
        return new AuthResponse(token, "Bearer", expiresIn, user.getRol().name(), summary);
    }
}
