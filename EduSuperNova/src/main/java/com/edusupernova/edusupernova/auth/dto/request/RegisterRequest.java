package com.edusupernova.edusupernova.auth.dto.request;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

/**
 * POST /auth/register
 *
 * NOTE: rol is NOT accepted from the client.
 * Every new user is STUDENT by default.
 * Admins are promoted via SQL or the admin panel only.
 */
public record RegisterRequest(
        @NotBlank
        @Size(min = 3, max = 50)
        String username,

        @NotBlank @Email
        String email,

        @NotBlank
        @Size(min = 8, max = 100)
        String password
) {}