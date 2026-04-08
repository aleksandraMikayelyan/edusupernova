package com.edusupernova.edusupernova.dto.request;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;

/**
 * POST /auth/login
 */
public record LoginRequest(
        @NotBlank @Email
        String email,

        @NotBlank
        String password
) {}