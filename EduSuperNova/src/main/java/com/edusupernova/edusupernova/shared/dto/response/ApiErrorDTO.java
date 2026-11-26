package com.edusupernova.edusupernova.shared.dto.response;

import java.time.LocalDateTime;

/**
 * Standard error response returned by GlobalExceptionHandler.
 * Follows RFC 7807 Problem Detail format.
 *
 * Example:
 * {
 *   "status": 409,
 *   "error": "Business Rule Violation",
 *   "message": "Test has already been submitted.",
 *   "path": "/api/tests/submit",
 *   "timestamp": "2026-04-08T10:30:00"
 * }
 */
public record ApiErrorDTO(
        int status,
        String error,
        String message,
        String path,
        LocalDateTime timestamp
) {
    // Convenience factory
    public static ApiErrorDTO of(int status, String error, String message, String path) {
        return new ApiErrorDTO(status, error, message, path, LocalDateTime.now());
    }
}