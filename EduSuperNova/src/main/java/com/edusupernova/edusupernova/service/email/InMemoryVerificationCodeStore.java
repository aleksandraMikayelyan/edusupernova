package com.edusupernova.edusupernova.service.email;

import org.springframework.stereotype.Component;

import java.time.Duration;
import java.time.Instant;
import java.util.Optional;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Thread-safe, in-memory implementation of {@link VerificationCodeStore}.
 *
 * SRP: sole responsibility is storing and retrieving time-limited codes.
 * TTL is enforced lazily on each read — no background cleanup thread needed.
 *
 * Limitation: state is lost on server restart and not shared across nodes.
 * For multi-instance deployments, replace this bean with a Redis implementation.
 */
@Component
public class InMemoryVerificationCodeStore implements VerificationCodeStore {

    /** Immutable entry: avoids race conditions between code and expiry. */
    private record Entry(String code, Instant expiresAt) {}

    private final ConcurrentHashMap<String, Entry> store = new ConcurrentHashMap<>();

    @Override
    public void save(String email, String code, Duration ttl) {
        store.put(normalise(email), new Entry(code, Instant.now().plus(ttl)));
    }

    @Override
    public Optional<String> find(String email) {
        String key   = normalise(email);
        Entry  entry = store.get(key);

        if (entry == null) {
            return Optional.empty();
        }
        if (Instant.now().isAfter(entry.expiresAt())) {
            store.remove(key);  // lazy eviction of expired entries
            return Optional.empty();
        }
        return Optional.of(entry.code());
    }

    @Override
    public void remove(String email) {
        store.remove(normalise(email));
    }

    /** Normalises email to lowercase so lookups are case-insensitive. */
    private String normalise(String email) {
        return email.toLowerCase();
    }
}
