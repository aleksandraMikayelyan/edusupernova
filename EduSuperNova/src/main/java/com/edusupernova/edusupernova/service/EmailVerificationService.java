package com.edusupernova.edusupernova.service;

/**
 * Business contract for the email-verification lifecycle.
 *
 * DIP: {@link UsersService} depends on this abstraction, not on a concrete
 * implementation, making it easy to test with mocks and to extend the behaviour
 * (e.g. rate-limiting, audit logging) without modifying the caller.
 */
public interface EmailVerificationService {

    /**
     * Generates a secure 6-digit code, stores it with a TTL, and dispatches
     * it to {@code email}.
     *
     * @param email the address that will receive the code
     */
    void sendCode(String email);

    /**
     * Validates that {@code code} matches the stored, unexpired code for
     * {@code email}, then removes it so codes are single-use.
     *
     * @param email the address the code was sent to
     * @param code  the 6-digit code submitted by the user
     * @throws com.edusupernova.edusupernova.exception.BusinessRuleException
     *         if the code is wrong or has expired
     */
    void verifyCode(String email, String code);
}
