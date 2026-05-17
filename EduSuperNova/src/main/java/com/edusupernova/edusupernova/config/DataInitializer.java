package com.edusupernova.edusupernova.config;

import com.edusupernova.edusupernova.exam.service.PaperConfigService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.stereotype.Component;

/**
 * Runs once on startup (after the full Spring context is ready) to ensure
 * database Paper records match the expected configuration.
 *
 * Delegates all transactional logic to {@link PaperConfigService} so that
 * lazy-loaded JPA associations are resolved inside a proper transaction.
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class DataInitializer implements ApplicationRunner {

    private final PaperConfigService paperConfigService;

    @Override
    public void run(ApplicationArguments args) {
        log.info("DataInitializer: synchronising paper configuration…");
        paperConfigService.synchronisePaperConfig();
        log.info("DataInitializer: done.");
    }
}
