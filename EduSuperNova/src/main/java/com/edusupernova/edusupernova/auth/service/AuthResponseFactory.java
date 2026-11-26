package com.edusupernova.edusupernova.auth.service;

import com.edusupernova.edusupernova.auth.dto.response.AuthResponse;
import com.edusupernova.edusupernova.auth.dto.response.UserSummaryDTO;
import com.edusupernova.edusupernova.config.JwtTokenUtil;
import com.edusupernova.edusupernova.config.UserPrincipal;
import com.edusupernova.edusupernova.model.Users;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

/**
 * Builds the JWT + UserSummaryDTO + AuthResponse triple shared by login,
 * registration, Google OAuth, and profile updates.
 */
@Component
@RequiredArgsConstructor
public class AuthResponseFactory {

    private final JwtTokenUtil jwtTokenUtil;

    public AuthResponse build(Users user) {
        String token     = jwtTokenUtil.generateToken(new UserPrincipal(user));
        long   expiresIn = jwtTokenUtil.getExpirationMs() / 1000;
        UserSummaryDTO summary = new UserSummaryDTO(
                user.getId(), user.getUsername(), user.getEmail(), user.getRol().name());
        return new AuthResponse(token, "Bearer", expiresIn, user.getRol().name(), summary);
    }
}
