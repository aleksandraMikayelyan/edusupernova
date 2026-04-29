package com.edusupernova.edusupernova.service;

import com.edusupernova.edusupernova.exception.BusinessRuleException;
import com.edusupernova.edusupernova.service.email.EmailSender;
import com.edusupernova.edusupernova.service.email.VerificationCodeStore;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.security.SecureRandom;
import java.time.Duration;

/**
 * Orchestrates the email-verification lifecycle: generation → storage → dispatch.
 *
 * SRP: owns only the verification flow; delegates email transport to
 *      {@link EmailSender} and code storage to {@link VerificationCodeStore}.
 *
 * OCP: swap either collaborator (e.g. Redis store, SendGrid sender) without
 *      touching this class.
 *
 * DIP: depends on the interfaces {@link EmailSender} and
 *      {@link VerificationCodeStore}, not on their implementations.
 */
@Service
@RequiredArgsConstructor
public class EmailVerificationServiceImpl implements EmailVerificationService {

    /** Upper bound (exclusive) for a 6-digit code: 000000–999999. */
    private static final int CODE_BOUND = 1_000_000;

    private final EmailSender           emailSender;
    private final VerificationCodeStore codeStore;

    @Value("${app.verification.code-ttl-minutes:10}")
    private int codeTtlMinutes;

    /**
     * SecureRandom is thread-safe and cryptographically strong — appropriate for
     * generating codes that must not be guessable.
     */
    private final SecureRandom secureRandom = new SecureRandom();

    @Override
    public void sendCode(String email) {
        String code = String.format("%06d", secureRandom.nextInt(CODE_BOUND));
        codeStore.save(email, code, Duration.ofMinutes(codeTtlMinutes));
        emailSender.sendVerificationCode(email, code);
    }

    @Override
    public void verifyCode(String email, String code) {
        String stored = codeStore.find(email).orElseThrow(() ->
                new BusinessRuleException(
                        "Verification code expired or not found. Please register again to receive a new code."));

        if (!stored.equals(code)) {
            throw new BusinessRuleException("Incorrect verification code. Please check your inbox and try again.");
        }

        // Single-use: remove after successful match
        codeStore.remove(email);
    }
}
