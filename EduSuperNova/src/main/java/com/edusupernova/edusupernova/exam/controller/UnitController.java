package com.edusupernova.edusupernova.exam.controller;

import com.edusupernova.edusupernova.data.PaperRepository;
import com.edusupernova.edusupernova.exam.dto.response.PaperDTO;
import com.edusupernova.edusupernova.model.Courses;
import com.edusupernova.edusupernova.model.Paper;
import com.edusupernova.edusupernova.exam.service.CourseService;
import com.edusupernova.edusupernova.exam.service.UnitService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import java.util.List;

/**
 * REST controller for the Units screen.
 * Returns course metadata, ordered unit list, and available papers in one response.
 */
@RestController
@RequestMapping("/api/units")
@RequiredArgsConstructor
public class UnitController {

    private final CourseService    courseService;
    private final UnitService      unitService;
    private final PaperRepository  paperRepository;

    @Value("${app.file.upload-dir}")
    private String uploadDir;

    /**
     * Returns the course display name, icon, ordered unit list, and papers.
     * Papers are used by the front-end to show "Check your knowledge" (MCQ)
     * and "Practice essay" (ESSAY) buttons with the correct paperId.
     */
    @GetMapping("/course/{courseId}")
    public ResponseEntity<CourseUnitsResponse> getUnitsScreenData(@PathVariable Integer courseId) {
        Courses course = courseService.getCourseBasicInfo(courseId);
        List<UnitService.UnitWithContent> units  = unitService.getUnitsByCourseId(courseId);
        List<PaperDTO>                    papers = paperRepository
                .findByCourseIdOrderByOrderIndex(courseId)
                .stream()
                .map(this::toDTO)
                .toList();

        Path sheetPath = Paths.get(uploadDir, "formula-sheets", courseId + ".pdf");
        boolean hasFormulaSheet = Files.exists(sheetPath);

        return ResponseEntity.ok(new CourseUnitsResponse(
                course.getCoursename(),
                course.getIcon(),
                units,
                papers,
                hasFormulaSheet
        ));
    }

    // ── Response DTO ──────────────────────────────────────────────────────────

    public record CourseUnitsResponse(
            String courseName,
            String courseIcon,
            List<UnitService.UnitWithContent> units,
            List<PaperDTO> papers,
            boolean hasFormulaSheet
    ) {}

    // ── Mapper ────────────────────────────────────────────────────────────────

    private PaperDTO toDTO(Paper p) {
        return new PaperDTO(
                p.getId(),
                p.getPaperName(),
                p.getInstructions(),
                p.getFormat().name(),
                p.getTotalQuestions(),
                p.getTimeLimitMinutes(),
                p.getOrderIndex()
        );
    }
}
