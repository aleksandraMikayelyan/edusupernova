package com.edusupernova.edusupernova.exception;

/**
 * Thrown when the Groq API returns an error or an unexpected response shape.
 * Mapped to HTTP 503 Service Unavailable by GlobalExceptionHandler.
 */
public class GroqApiException extends RuntimeException {
    public GroqApiException(String message) {
        super(message);
    }

    public GroqApiException(String message, Throwable cause) {
        super(message, cause);
    }
}
