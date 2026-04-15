package com.edusupernova.edusupernova.service;

import com.edusupernova.edusupernova.data.PaperRepository;
import com.edusupernova.edusupernova.model.Paper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * Ensures Paper records in the database have the correct configuration.
 *
 * Rules applied on every application startup (idempotent):
 *
 *   Math (MCQ)                → totalQuestions = 11
 *   Economics DATA_RESPONSE   → totalQuestions = 5
 *   Economics ESSAY           → totalQuestions = 4
 *   English / Language Paper 1 → format = READING_WRITING, totalQuestions = 3
 *   English / Language Paper 2 → format = MULTI_ESSAY
 *
 * Called by DataInitializer via ApplicationRunner so it runs after
 * the full Spring context is ready and all JPA repositories are usable.
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class PaperConfigService {

    private final PaperRepository paperRepository;

    @Transactional
    public void synchronisePaperConfig() {
        int updated = 0;

        for (Paper p : paperRepository.findAll()) {
            // Lazy-load is safe here because we are inside a transaction
            String cn = p.getCourse().getCoursename().toLowerCase();
            String pn = p.getPaperName().toLowerCase();
            boolean changed = false;

            // ── Math MCQ → exactly 11 questions ──────────────────────────────
            if (cn.contains("math") && p.getFormat() == Paper.PaperFormat.MCQ) {
                if (!Integer.valueOf(11).equals(p.getTotalQuestions())) {
                    p.setTotalQuestions(11);
                    changed = true;
                }
            }

            // ── Economics DATA_RESPONSE → 5 questions ─────────────────────────
            if (isEcon(cn) && p.getFormat() == Paper.PaperFormat.DATA_RESPONSE) {
                if (!Integer.valueOf(5).equals(p.getTotalQuestions())) {
                    p.setTotalQuestions(5);
                    changed = true;
                }
            }

            // ── Economics ESSAY → 4 questions ────────────────────────────────
            if (isEcon(cn) && p.getFormat() == Paper.PaperFormat.ESSAY) {
                if (!Integer.valueOf(4).equals(p.getTotalQuestions())) {
                    p.setTotalQuestions(4);
                    changed = true;
                }
            }

            // ── English / Language Paper 1 → READING_WRITING, 3 essays ──────
            if (isLang(cn) && pn.contains("paper 1")) {
                if (p.getFormat() != Paper.PaperFormat.READING_WRITING) {
                    p.setFormat(Paper.PaperFormat.READING_WRITING);
                    changed = true;
                }
                if (!Integer.valueOf(3).equals(p.getTotalQuestions())) {
                    p.setTotalQuestions(3);
                    changed = true;
                }
            }

            // ── English / Language Paper 2 → MULTI_ESSAY ─────────────────────
            if (isLang(cn) && pn.contains("paper 2")) {
                if (p.getFormat() != Paper.PaperFormat.MULTI_ESSAY) {
                    p.setFormat(Paper.PaperFormat.MULTI_ESSAY);
                    changed = true;
                }
            }

            if (changed) {
                paperRepository.save(p);
                log.info("PaperConfig: updated '{}' for course '{}'",
                        p.getPaperName(), p.getCourse().getCoursename());
                updated++;
            }
        }

        if (updated == 0) {
            log.debug("PaperConfig: all papers already configured correctly.");
        } else {
            log.info("PaperConfig: {} paper(s) reconfigured on startup.", updated);
        }
    }

    private boolean isEcon(String courseName) {
        return courseName.contains("economics") || courseName.contains("economy");
    }

    private boolean isLang(String courseName) {
        return courseName.contains("english")
                || courseName.contains("language")
                || courseName.contains("literature");
    }
}
