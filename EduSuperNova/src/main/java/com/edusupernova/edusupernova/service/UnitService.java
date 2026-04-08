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

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class UnitService {

    private static final String BASE_FOLDER          = "EduSuperNova";
    private static final String CONTENT_NOT_FOUND    = "ERROR: File not found at: ";
    private static final String CONTENT_READ_FAILURE = "ERROR: Critical failure reading file.";

    private final UnitRepository unitRepository;

    /** Internal record paired with UnitDTO at the controller boundary. */
    public record UnitWithContent(Unit unit, String content) {}

    public List<UnitWithContent> getUnitsByCourseId(Integer courseId) {
        return unitRepository.findByCourseIdOrderByQueueAsc(courseId)
                .stream()
                .map(u -> new UnitWithContent(u, loadContent(u.getSummaryPath())))
                .toList();
    }

    public List<Unit> getByExamId(int examId) {
        return unitRepository.findByExamIdOrderByQueueAsc(examId);
    }

    /** Returns the unit or throws ResourceNotFoundException (added in msg 2). */
    public Unit getByIdOrThrow(int unitId) {
        return unitRepository.findById(unitId)
                .orElseThrow(() -> new com.edusupernova.edusupernova.exception.ResourceNotFoundException(
                        "Unit not found: " + unitId));
    }

    public UnitWithContent getByIdWithContent(int unitId) {
        Unit unit = getByIdOrThrow(unitId);
        return new UnitWithContent(unit, loadContent(unit.getSummaryPath()));
    }

    private String loadContent(String rawDbPath) {
        Path fullPath = buildFilePath(rawDbPath);
        try {
            if (Files.exists(fullPath)) {
                return Files.readString(fullPath, StandardCharsets.UTF_8);
            }
            log.warn("Unit content file not found: {}", fullPath.toAbsolutePath());
            return CONTENT_NOT_FOUND + fullPath.toAbsolutePath();
        } catch (IOException ex) {
            log.error("Failed to read unit content file: {}", fullPath.toAbsolutePath(), ex);
            return CONTENT_READ_FAILURE;
        }
    }

    private Path buildFilePath(String rawDbPath) {
        String[] segments = rawDbPath.trim().replace("\\", "/").split("/");
        Path base = Paths.get(System.getProperty("user.dir"), BASE_FOLDER);
        for (String segment : segments) {
            if (!segment.isEmpty()) base = base.resolve(segment);
        }
        return base;
    }
}