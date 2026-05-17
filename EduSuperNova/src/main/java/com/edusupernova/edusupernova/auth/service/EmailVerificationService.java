package com.edusupernova.edusupernova.auth.service;

import com.edusupernova.edusupernova.data.UserRepository;
import com.edusupernova.edusupernova.model.Users;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.security.SecureRandom;
import java.time.Instant;

@Service
@RequiredArgsConstructor
public class EmailVerificationService {

    private final UserRepository userRepository;
    private final EmailService   emailService;

    @Value("${app.verification.code-ttl-minutes:10}")
    private int codeTtlMinutes;

    private static final SecureRandom RANDOM = new SecureRandom();

    /**
     * Generates a 6-digit code, persists it with an expiry, and sends the email.
     */
    @Transactional
    public void sendCode(String email) {
        Users user = userRepository.findByEmail(email);
        if (user == null) return;

        String code   = String.format("%06d", RANDOM.nextInt(1_000_000));
        Instant expiry = Instant.now().plusSeconds(codeTtlMinutes * 60L);

        user.setVerificationCode(code);
        user.setVerificationCodeExpiry(expiry);
        userRepository.save(user);

        emailService.sendVerificationCode(email, code);
    }

    /**
     * Returns true and clears the stored code if the code is correct and not expired.
     * Returns false if the code is wrong or expired (never throws — caller decides the response).
     */
    @Transactional
    public boolean validateCode(String email, String code) {
        Users user = userRepository.findByEmail(email);
        if (user == null) return false;
        if (user.getVerificationCode() == null) return false;
        if (!user.getVerificationCode().equals(code)) return false;
        if (Instant.now().isAfter(user.getVerificationCodeExpiry())) return false;

        user.setVerificationCode(null);
        user.setVerificationCodeExpiry(null);
        userRepository.save(user);
        return true;
    }
}
