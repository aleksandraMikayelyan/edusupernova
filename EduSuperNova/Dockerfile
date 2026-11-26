# ── Stage 1: Build ───────────────────────────────────────────────────────────
# Full Maven + JDK image — only used to compile and package the JAR.
# This stage is discarded afterwards; it never ships to production.
FROM maven:3.9-eclipse-temurin-21 AS build

WORKDIR /app

# Copy dependency manifest first so Docker caches the download layer.
# Re-downloading 200+ MB of deps only happens when pom.xml changes.
COPY pom.xml .
RUN mvn dependency:go-offline -q

# Copy source and build the fat JAR (skip tests — they need a live MySQL
# connection that isn't available at build time; Render only provides DB_URL
# at runtime via environment variables)
COPY src ./src
RUN mvn package -DskipTests -q

# ── Stage 2: Runtime ──────────────────────────────────────────────────────────
# Slim JRE-only image (~90 MB vs ~500 MB for the full JDK).
# Only the compiled JAR is copied from stage 1.
FROM eclipse-temurin:21-jre-alpine

WORKDIR /app

# Create a folder for uploaded files (formula sheets, etc.)
RUN mkdir -p /app/uploads/formula-sheets

# Copy ONLY the fat JAR from the build stage
COPY --from=build /app/target/edusupernova-0.0.1-SNAPSHOT.jar app.jar

# Render injects PORT at runtime (default 10000).
# Spring Boot reads it via ${PORT:8080} in application.properties.
EXPOSE 10000

ENTRYPOINT ["java", \
  "-Xmx300m", \
  "-Xms64m", \
  "-XX:+ExitOnOutOfMemoryError", \
  "-jar", "app.jar"]
