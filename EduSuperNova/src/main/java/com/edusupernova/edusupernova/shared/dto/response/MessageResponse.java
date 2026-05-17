package com.edusupernova.edusupernova.shared.dto.response;

/**
 * Generic single-field response for operations that don't return a resource
 * (e.g. "Verification code sent to your email").
 */
public record MessageResponse(String message) {}
