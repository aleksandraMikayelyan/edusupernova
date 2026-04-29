package com.edusupernova.edusupernova.exception;

/**
 * Thrown when the authenticated user attempts to access a resource that belongs
 * to another user (e.g. ownership check on a test).
 *
 * Mapped to HTTP 403 Forbidden by GlobalExceptionHandler.
 */
public class ForbiddenException extends RuntimeException {
    public ForbiddenException(String message) {
        super(message);
    }
}
