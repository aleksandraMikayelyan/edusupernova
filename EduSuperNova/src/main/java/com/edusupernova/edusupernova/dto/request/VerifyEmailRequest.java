package com.edusupernova.edusupernova.dto.request;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;

/**
 * Request body for POST /api/users/verify-email.
 *
 * Bean Validation annotations enforce the contract at the HTTP boundary
 * before any service logic runs.
 */
public record VerifyEmailRequest(

        @Email(message = "Must be a valid email address")
        @NotBlank(message = "Email is required")
        String email,

        @NotBlank(message = "Verification code is required")
        @Pattern(regexp = "\\d{6}", message = "Code must be exactly 6 digits")
        String code
) {}
