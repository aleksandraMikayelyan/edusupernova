package com.edusupernova.edusupernova.exception;

/**
 * Thrown when a request is syntactically valid but violates a business rule:
 * duplicate enrollment, email already taken, trying to start a test while
 * another is in progress, etc.
 *
 * Mapped to HTTP 409 Conflict by GlobalExceptionHandler.
 */
public class BusinessRuleException extends RuntimeException {
    public BusinessRuleException(String message) {
        super(message);
    }
}
