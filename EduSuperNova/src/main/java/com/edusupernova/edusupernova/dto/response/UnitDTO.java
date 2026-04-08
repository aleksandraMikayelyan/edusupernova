package com.edusupernova.edusupernova.dto.response;

/**
 * Lightweight user info embedded in AuthResponse.
 * Never expose the password field.
 */
public record UserSummaryDTO(
        Integer id,
        String username,
        String email,
        String rol              // "STUDENT" or "ADMIN"
) {}