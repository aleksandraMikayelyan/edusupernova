package com.edusupernova.edusupernova.service;

import com.edusupernova.edusupernova.data.UnitRepository;
import com.edusupernova.edusupernova.model.Unit;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

/**
 * Handles unit retrieval and resolves each unit's summary content
 * from the filesystem at request time.
 *
 * SRP – file-content resolution is extracted into a dedicated private helper,
 *       keeping the public API clean and the logic independently testable.
 * DIP – depends on the UnitRepository abstraction via constructor injection.
 */
@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class UnitService {

    // ── Constants ─────────────────────────────────────────────────────────────

    private static final String BASE_FOLDER           = "EduSuperNova";
    private static final String CONTENT_NOT_FOUND     = "ERROR: File not found at: ";
    private static final String CONTENT_READ_FAILURE  = "ERROR: Critical failure reading file.";

    // ── Dependencies ──────────────────────────────────────────────────────────

    private final UnitRepository unitRepository;

    // ── Public API ────────────────────────────────────────────────────────────

    /**
     * Returns all units for a course ordered by queue position,
     * with each unit's {@code summary_path} field replaced by the actual
     * file content read from disk.
     */
    public List<Unit> getUnitsByCourseId(Integer courseId) {
        List<Unit> units = unitRepository.findByCourseIdOrderByQueueAsc(courseId);
        units.forEach(this::resolveFileContent);
        return units;
    }

    /** Returns all units across every course belonging to an exam, ordered by queue. */
    public List<Unit> getByExamId(int examId) {
        return unitRepository.findByExamIdOrderByQueueAsc(examId);
    }

    /** Returns a unit by ID, or {@code null} if not found. */
    public Unit getById(int unitId) {
        return unitRepository.findById(unitId).orElse(null);
    }

    /**
     * Returns a unit by ID.
     *
     * @throws RuntimeException if the unit does not exist
     */
    public Unit getByIdOrThrow(int unitId) {
        return unitRepository.findById(unitId)
                .orElseThrow(() -> new RuntimeException("Unit not found: " + unitId));
    }

    // ── Private helpers ───────────────────────────────────────────────────────

    /**
     * Resolves the filesystem path stored in {@code unit.summary_path} and
     * replaces the field value with the file's text content.
     *
     * Path segments are split on both slash styles to handle Windows paths
     * stored in the database.
     */
    private void resolveFileContent(Unit unit) {
        Path fullPath = buildFilePath(unit.getSummary_path());
        log.debug("Attempting to load unit content from: {}", fullPath.toAbsolutePath());

        try {
            if (Files.exists(fullPath)) {
                unit.setSummary_path(Files.readString(fullPath, StandardCharsets.UTF_8));
            } else {
                log.warn("Unit content file not found: {}", fullPath.toAbsolutePath());
                unit.setSummary_path(CONTENT_NOT_FOUND + fullPath.toAbsolutePath());
            }
        } catch (IOException ex) {
            log.error("Failed to read unit content file: {}", fullPath.toAbsolutePath(), ex);
            unit.setSummary_path(CONTENT_READ_FAILURE);
        }
    }

    /**
     * Converts a raw DB path string (may contain backslashes) into a
     * cross-platform {@link Path} rooted at {@code <working-dir>/EduSuperNova}.
     */
    private Path buildFilePath(String rawDbPath) {
        String[] segments = rawDbPath.trim().replace("\\", "/").split("/");
        Path base = Paths.get(System.getProperty("user.dir"), BASE_FOLDER);
        for (String segment : segments) {
            if (!segment.isEmpty()) {
                base = base.resolve(segment);
            }
        }
        return base;
    }
}