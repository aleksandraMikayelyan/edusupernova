package com.edusupernova.edusupernova.dto.request;

import jakarta.validation.constraints.NotBlank;

/**
 * POST /api/users/google-auth
 * The frontend obtains this token via Google Sign-In and sends it here for verification.
 */
public record GoogleAuthRequest(
        @NotBlank
        String idToken
) {}
