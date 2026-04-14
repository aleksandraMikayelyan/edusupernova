package com.edusupernova.edusupernova.exception;

import com.edusupernova.edusupernova.dto.response.ApiErrorDTO;
import jakarta.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.util.stream.Collectors;

/**
 * Central exception → HTTP response mapper.
 *
 * Every controller endpoint funnels errors through here so responses have a
 * consistent shape (ApiErrorDTO) and callers can tell 404 from 409 from 500.
 *
 * Order of handlers matters: more specific exceptions first, catch-all last.
 */
@Slf4j
@RestControllerAdvice
public class GlobalExceptionHandler {

    // ── 404 ────────────────────────────────────────────────────────────────
    @ExceptionHandler(ResourceNotFoundException.class)
    public ResponseEntity<ApiErrorDTO> handleNotFound(
            ResourceNotFoundException ex, HttpServletRequest request) {
        return build(HttpStatus.NOT_FOUND, "Resource Not Found", ex.getMessage(), request);
    }

    // ── 409 ────────────────────────────────────────────────────────────────
    @ExceptionHandler(BusinessRuleException.class)
    public ResponseEntity<ApiErrorDTO> handleBusinessRule(
            BusinessRuleException ex, HttpServletRequest request) {
        return build(HttpStatus.CONFLICT, "Business Rule Violation", ex.getMessage(), request);
    }

    // ── 400 (bean validation on @Valid @RequestBody) ──────────────────────
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ApiErrorDTO> handleValidation(
            MethodArgumentNotValidException ex, HttpServletRequest request) {
        String message = ex.getBindingResult().getFieldErrors().stream()
                .map(e -> e.getField() + ": " + e.getDefaultMessage())
                .collect(Collectors.joining("; "));
        return build(HttpStatus.BAD_REQUEST, "Validation Failed", message, request);
    }

    // ── 400 (bad arguments / bad state from services) ──────────────────────
    @ExceptionHandler({IllegalArgumentException.class, IllegalStateException.class})
    public ResponseEntity<ApiErrorDTO> handleIllegalArgument(
            RuntimeException ex, HttpServletRequest request) {
        return build(HttpStatus.BAD_REQUEST, "Bad Request", ex.getMessage(), request);
    }

    // ── 401 ────────────────────────────────────────────────────────────────
    @ExceptionHandler({BadCredentialsException.class, AuthenticationException.class})
    public ResponseEntity<ApiErrorDTO> handleAuth(
            Exception ex, HttpServletRequest request) {
        return build(HttpStatus.UNAUTHORIZED, "Authentication Failed",
                "Invalid email or password", request);
    }

    // ── 503 (Groq down / misbehaving) ──────────────────────────────────────
    @ExceptionHandler(GroqApiException.class)
    public ResponseEntity<ApiErrorDTO> handleGroq(
            GroqApiException ex, HttpServletRequest request) {
        log.error("Groq API error: {}", ex.getMessage(), ex);
        return build(HttpStatus.SERVICE_UNAVAILABLE, "AI Service Unavailable",
                "Evaluation service is temporarily unavailable. Please try again shortly.",
                request);
    }

    // ── 500 fallback ───────────────────────────────────────────────────────
    @ExceptionHandler(Exception.class)
    public ResponseEntity<ApiErrorDTO> handleGeneric(
            Exception ex, HttpServletRequest request) {
        log.error("Unhandled exception on {}: {}", request.getRequestURI(), ex.getMessage(), ex);
        return build(HttpStatus.INTERNAL_SERVER_ERROR, "Internal Server Error",
                "An unexpected error occurred.", request);
    }

    // ── helper ─────────────────────────────────────────────────────────────
    private ResponseEntity<ApiErrorDTO> build(
            HttpStatus status, String error, String message, HttpServletRequest request) {
        ApiErrorDTO body = ApiErrorDTO.of(status.value(), error, message, request.getRequestURI());
        return ResponseEntity.status(status).body(body);
    }
}
