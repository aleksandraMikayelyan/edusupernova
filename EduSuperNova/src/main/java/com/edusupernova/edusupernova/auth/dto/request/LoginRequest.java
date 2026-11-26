package com.edusupernova.edusupernova.auth.dto.request;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;

/**
 * POST /api/users/login
 */
public record LoginRequest(
        @NotBlank @Email
        String email,

        @NotBlank
        String password
) {}