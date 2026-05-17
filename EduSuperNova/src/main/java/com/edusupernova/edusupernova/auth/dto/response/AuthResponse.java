package com.edusupernova.edusupernova.auth.dto.response;

/**
 * Returned after login and register.
 * accessToken → stored in memory by the frontend (never localStorage)
 * rol         → used by frontend to redirect to /admin or /dashboard
 */
public record AuthResponse(
        String accessToken,
        String tokenType,       // always "Bearer"
        Long expiresIn,         // seconds until access token expires (e.g. 900 = 15 min)
        String rol,
        UserSummaryDTO user
) {
    // Convenience constructor so existing code calling AuthResponse(token, rol) still compiles
    public AuthResponse(String accessToken, String rol) {
        this(accessToken, "Bearer", 900L, rol, null);
    }
}
