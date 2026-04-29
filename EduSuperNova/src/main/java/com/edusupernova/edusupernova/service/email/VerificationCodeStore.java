package com.edusupernova.edusupernova.service.email;

import java.time.Duration;
import java.util.Optional;

/**
 * Port for temporary storage of email-verification codes.
 *
 * ISP: only exposes the three operations needed by the verification flow.
 * DIP: callers depend on this interface, not on a specific storage backend.
 *
 * Swap the in-memory implementation for Redis or a DB table without touching
 * any business logic.
 */
public interface VerificationCodeStore {

    /**
     * Persists {@code code} for {@code email}, expiring after {@code ttl}.
     * Overwrites any previously stored code for the same address.
     */
    void save(String email, String code, Duration ttl);

    /**
     * Returns the stored code if it exists and has not yet expired.
     * Returns {@link Optional#empty()} when absent or expired (and removes stale entry).
     */
    Optional<String> find(String email);

    /**
     * Removes the entry for {@code email}.
     * Must be called after a successful verification so codes are single-use.
     */
    void remove(String email);
}
