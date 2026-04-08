# 🦚 EduSupernova — Backend API

> **"Learn. Dominate. Shine."**
> AI-powered exam preparation platform — Spring Boot 3.4 REST API

[![Java](https://img.shields.io/badge/Java-21-orange?logo=openjdk)](https://openjdk.org/projects/jdk/21/)
[![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.4.x-brightgreen?logo=springboot)](https://spring.io/projects/spring-boot)
[![MySQL](https://img.shields.io/badge/MySQL-8.0-blue?logo=mysql)](https://www.mysql.com/)
[![JWT](https://img.shields.io/badge/JWT-Auth-yellow?logo=jsonwebtokens)](https://jwt.io/)
[![Groq](https://img.shields.io/badge/Groq-AI%20Feedback-purple)](https://groq.com/)
[![License](https://img.shields.io/badge/License-MIT-lightgrey)](LICENSE)

---

## Table of Contents

1. [Project Overview](#1-project-overview)
2. [Tech Stack](#2-tech-stack)
3. [Architecture](#3-architecture)
4. [Prerequisites](#4-prerequisites)
5. [Getting Started](#5-getting-started)
6. [Environment Configuration](#6-environment-configuration)
7. [Database Setup](#7-database-setup)
8. [Project Structure](#8-project-structure)
9. [Authentication & Security](#9-authentication--security)
10. [API Reference](#10-api-reference)
11. [Daily Test Limit System](#11-daily-test-limit-system)
12. [Groq AI Integration](#12-groq-ai-integration)
13. [Running Tests](#13-running-tests)
14. [Docker Deployment](#14-docker-deployment)
15. [Contributing](#15-contributing)

---

## 1. Project Overview

EduSupernova is a freemium AI-powered exam preparation platform targeting **A Levels, SAT, IELTS, ACT, and TOEFL** students. This repository contains the **Spring Boot 3.4 backend** which powers:

- 🔐 **JWT Authentication** — access tokens (15 min) + HttpOnly refresh tokens (7 days)
- 📚 **Exam & Question Management** — structured by Exam Type → Course → Unit hierarchy
- 🎯 **Randomised 20-Question Tests** — drawn from a question pool per course
- 🤖 **Instant AI Feedback** — per-question explanations via Groq's fast LLM
- 🚦 **Freemium Rate Limiting** — free-tier students capped at 2 tests/day
- 👑 **Admin Panel API** — full CRUD for questions, exams, and uploads

---

## 2. Tech Stack

| Layer | Technology |
|---|---|
| Language | Java 21 (Virtual Threads enabled) |
| Framework | Spring Boot 3.4.x |
| Security | Spring Security 6 + JJWT 0.12.x |
| Persistence | Spring Data JPA + Hibernate 6 |
| Database | MySQL 8.0 |
| AI Integration | Groq API (`llama3-8b-8192`) |
| Build Tool | Maven 3.9+ |
| Testing | JUnit 5, Mockito, Testcontainers |
| Containerisation | Docker + Docker Compose |
| Migrations | Flyway |

---

## 3. Architecture

EduSupernova follows **Clean Architecture** with strict layer separation:

```
┌──────────────────────────────────────────────┐
│              Presentation Layer              │
│   @RestController · DTOs · @ControllerAdvice │
├──────────────────────────────────────────────┤
│              Application Layer               │
│         @Service · Use Case Classes          │
├──────────────────────────────────────────────┤
│               Domain Layer                   │
│     @Entity · Domain Events · Business Rules │
├──────────────────────────────────────────────┤
│            Infrastructure Layer              │
│  @Repository · JPA · Groq Client · Security  │
└──────────────────────────────────────────────┘
```

**Key design decisions:**

- **Virtual Threads** (`spring.threads.virtual.enabled=true`) for high concurrency with zero thread-pool tuning
- **Record DTOs** for immutable, concise request/response objects
- **`@ControllerAdvice`** global exception handler with RFC 7807 Problem Detail responses
- **Soft deletes** on `questions` and `exam_types` via `deleted_at` timestamp
- **Refresh token rotation** — old token invalidated on each refresh

---

## 4. Prerequisites

| Tool | Minimum Version |
|---|---|
| JDK | 21 (LTS) |
| Maven | 3.9+ |
| MySQL | 8.0+ |
| Docker *(optional)* | 24+ |

> **Recommended:** Use [SDKMAN](https://sdkman.io/) to manage Java versions:
> ```bash
> sdk install java 21.0.3-tem
> ```

---

## 5. Getting Started

### Clone the repository

```bash
git clone https://github.com/your-org/edusupernova-backend.git
cd edusupernova-backend
```

### Install dependencies

```bash
mvn clean install -DskipTests
```

### Run in development mode

```bash
mvn spring-boot:run -Dspring-boot.run.profiles=dev
```

The server starts on **`http://localhost:8080`**.

> On first run, Flyway automatically creates all tables and seeds initial data.

---

## 6. Environment Configuration

### `src/main/resources/application.yml`

```yaml
spring:
  application:
    name: edusupernova-api

  datasource:
    url: jdbc:mysql://localhost:3306/edusupernova?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC
    username: ${DB_USERNAME:root}
    password: ${DB_PASSWORD:root}
    driver-class-name: com.mysql.cj.jdbc.Driver

  jpa:
    hibernate:
      ddl-auto: validate          # Flyway owns DDL
    show-sql: false
    properties:
      hibernate:
        format_sql: true
        dialect: org.hibernate.dialect.MySQL8Dialect

  flyway:
    enabled: true
    locations: classpath:db/migration

  threads:
    virtual:
      enabled: true               # Java 21 Virtual Threads

server:
  port: 8080
  servlet:
    context-path: /api/v1

app:
  jwt:
    secret: ${JWT_SECRET}         # Min 256-bit Base64 secret
    access-token-expiry-ms: 900000        # 15 minutes
    refresh-token-expiry-ms: 604800000    # 7 days

  groq:
    api-key: ${GROQ_API_KEY}
    model: llama3-8b-8192
    base-url: https://api.groq.com/openai/v1

  cors:
    allowed-origins: ${CORS_ORIGINS:http://localhost:5173}

  rate-limit:
    free-daily-tests: 2
```

### Required Environment Variables

Create a `.env` file in the project root (never commit this file):

```dotenv
# Database
DB_USERNAME=edusupernova_user
DB_PASSWORD=super_secret_password

# JWT — generate with: openssl rand -base64 64
JWT_SECRET=your_256bit_base64_encoded_secret_here

# Groq AI
GROQ_API_KEY=gsk_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

# CORS (comma-separated for multiple origins)
CORS_ORIGINS=http://localhost:5173,https://edusupernova.com
```

> ⚠️ Add `.env` to `.gitignore` immediately. Never commit secrets to version control.

---

## 7. Database Setup

### Create the MySQL database and user

```sql
CREATE DATABASE edusupernova CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'edusupernova_user'@'localhost' IDENTIFIED BY 'your_password';
GRANT ALL PRIVILEGES ON edusupernova.* TO 'edusupernova_user'@'localhost';
FLUSH PRIVILEGES;
```

### Schema Overview

Flyway migrations in `src/main/resources/db/migration/` apply the full schema automatically.

```
exam_types
    └── courses  (M:M via exam_type_courses)
            └── units  (ordered by unit_order)
                    └── questions  (soft-deleted)

users
    └── enrollments  (user ↔ exam_type)
    └── test_sessions
            └── test_answers  (per-question result + AI feedback)
    └── daily_test_counters  (rate limiting)

refresh_tokens  (HttpOnly cookie strategy)
```

### Full Schema (V1__initial_schema.sql excerpt)

```sql
CREATE TABLE users (
    id          BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    email       VARCHAR(255) NOT NULL UNIQUE,
    username    VARCHAR(100) NOT NULL UNIQUE,
    password    VARCHAR(255) NOT NULL,
    role        ENUM('STUDENT','ADMIN') NOT NULL DEFAULT 'STUDENT',
    is_premium  BOOLEAN NOT NULL DEFAULT FALSE,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_users_email (email)
);

CREATE TABLE exam_types (
    id          BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(100) NOT NULL UNIQUE,   -- 'A Levels', 'SAT', etc.
    description TEXT,
    icon_url    VARCHAR(500),
    deleted_at  TIMESTAMP NULL DEFAULT NULL,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE courses (
    id            BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    exam_type_id  BIGINT UNSIGNED NOT NULL,
    name          VARCHAR(200) NOT NULL,
    description   TEXT,
    deleted_at    TIMESTAMP NULL DEFAULT NULL,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (exam_type_id) REFERENCES exam_types(id),
    INDEX idx_courses_exam_type (exam_type_id)
);

CREATE TABLE units (
    id           BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    course_id    BIGINT UNSIGNED NOT NULL,
    name         VARCHAR(200) NOT NULL,
    unit_order   SMALLINT UNSIGNED NOT NULL DEFAULT 1,
    summary      MEDIUMTEXT,
    deleted_at   TIMESTAMP NULL DEFAULT NULL,
    FOREIGN KEY (course_id) REFERENCES courses(id),
    INDEX idx_units_course (course_id)
);

CREATE TABLE questions (
    id            BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    unit_id       BIGINT UNSIGNED NOT NULL,
    question_text TEXT NOT NULL,
    option_a      VARCHAR(1000) NOT NULL,
    option_b      VARCHAR(1000) NOT NULL,
    option_c      VARCHAR(1000) NOT NULL,
    option_d      VARCHAR(1000) NOT NULL,
    correct_option ENUM('A','B','C','D') NOT NULL,
    explanation   TEXT,
    difficulty    ENUM('EASY','MEDIUM','HARD') DEFAULT 'MEDIUM',
    deleted_at    TIMESTAMP NULL DEFAULT NULL,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (unit_id) REFERENCES units(id),
    INDEX idx_questions_unit (unit_id),
    INDEX idx_questions_active (unit_id, deleted_at)
);

CREATE TABLE enrollments (
    id            BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id       BIGINT UNSIGNED NOT NULL,
    exam_type_id  BIGINT UNSIGNED NOT NULL,
    enrolled_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uq_user_exam (user_id, exam_type_id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (exam_type_id) REFERENCES exam_types(id)
);

CREATE TABLE test_sessions (
    id           BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id      BIGINT UNSIGNED NOT NULL,
    course_id    BIGINT UNSIGNED NOT NULL,
    score        TINYINT UNSIGNED DEFAULT 0,
    total        TINYINT UNSIGNED DEFAULT 20,
    status       ENUM('IN_PROGRESS','COMPLETED','ABANDONED') DEFAULT 'IN_PROGRESS',
    started_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP NULL,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (course_id) REFERENCES courses(id),
    INDEX idx_sessions_user (user_id),
    INDEX idx_sessions_user_date (user_id, started_at)
);

CREATE TABLE test_answers (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    session_id      BIGINT UNSIGNED NOT NULL,
    question_id     BIGINT UNSIGNED NOT NULL,
    chosen_option   ENUM('A','B','C','D') NOT NULL,
    is_correct      BOOLEAN NOT NULL,
    ai_feedback     TEXT,
    answered_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (session_id) REFERENCES test_sessions(id),
    FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE daily_test_counters (
    id         BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id    BIGINT UNSIGNED NOT NULL,
    test_date  DATE NOT NULL,
    test_count TINYINT UNSIGNED NOT NULL DEFAULT 0,
    UNIQUE KEY uq_user_date (user_id, test_date),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE refresh_tokens (
    id          BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id     BIGINT UNSIGNED NOT NULL UNIQUE,
    token       VARCHAR(500) NOT NULL UNIQUE,
    expires_at  TIMESTAMP NOT NULL,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    INDEX idx_refresh_token (token)
);
```

---

## 8. Project Structure

```
edusupernova-backend/
├── src/
│   ├── main/
│   │   ├── java/com/edusupernova/
│   │   │   ├── EduSupernovaApplication.java
│   │   │   │
│   │   │   ├── config/
│   │   │   │   ├── SecurityConfig.java
│   │   │   │   ├── JwtConfig.java
│   │   │   │   ├── CorsConfig.java
│   │   │   │   └── GroqConfig.java
│   │   │   │
│   │   │   ├── security/
│   │   │   │   ├── JwtTokenProvider.java
│   │   │   │   ├── JwtAuthenticationFilter.java
│   │   │   │   ├── CustomUserDetailsService.java
│   │   │   │   └── SecurityConstants.java
│   │   │   │
│   │   │   ├── controller/
│   │   │   │   ├── AuthController.java
│   │   │   │   ├── ExamTypeController.java
│   │   │   │   ├── CourseController.java
│   │   │   │   ├── UnitController.java
│   │   │   │   ├── TestSessionController.java
│   │   │   │   ├── EnrollmentController.java
│   │   │   │   └── admin/
│   │   │   │       ├── AdminQuestionController.java
│   │   │   │       └── AdminExamController.java
│   │   │   │
│   │   │   ├── service/
│   │   │   │   ├── AuthService.java
│   │   │   │   ├── ExamTypeService.java
│   │   │   │   ├── CourseService.java
│   │   │   │   ├── UnitService.java
│   │   │   │   ├── TestSessionService.java
│   │   │   │   ├── DailyLimitService.java
│   │   │   │   ├── EnrollmentService.java
│   │   │   │   └── GroqFeedbackService.java
│   │   │   │
│   │   │   ├── repository/
│   │   │   │   ├── UserRepository.java
│   │   │   │   ├── ExamTypeRepository.java
│   │   │   │   ├── CourseRepository.java
│   │   │   │   ├── UnitRepository.java
│   │   │   │   ├── QuestionRepository.java
│   │   │   │   ├── TestSessionRepository.java
│   │   │   │   ├── TestAnswerRepository.java
│   │   │   │   ├── DailyTestCounterRepository.java
│   │   │   │   ├── EnrollmentRepository.java
│   │   │   │   └── RefreshTokenRepository.java
│   │   │   │
│   │   │   ├── entity/
│   │   │   │   ├── User.java
│   │   │   │   ├── ExamType.java
│   │   │   │   ├── Course.java
│   │   │   │   ├── Unit.java
│   │   │   │   ├── Question.java
│   │   │   │   ├── TestSession.java
│   │   │   │   ├── TestAnswer.java
│   │   │   │   ├── DailyTestCounter.java
│   │   │   │   ├── Enrollment.java
│   │   │   │   └── RefreshToken.java
│   │   │   │
│   │   │   ├── dto/
│   │   │   │   ├── request/
│   │   │   │   │   ├── LoginRequest.java        (record)
│   │   │   │   │   ├── RegisterRequest.java     (record)
│   │   │   │   │   ├── SubmitAnswerRequest.java (record)
│   │   │   │   │   └── CreateQuestionRequest.java (record)
│   │   │   │   └── response/
│   │   │   │       ├── AuthResponse.java        (record)
│   │   │   │       ├── ExamTypeResponse.java    (record)
│   │   │   │       ├── CourseResponse.java      (record)
│   │   │   │       ├── UnitResponse.java        (record)
│   │   │   │       ├── QuestionResponse.java    (record)
│   │   │   │       ├── TestSessionResponse.java (record)
│   │   │   │       ├── AnswerFeedbackResponse.java (record)
│   │   │   │       └── TestReportResponse.java  (record)
│   │   │   │
│   │   │   └── exception/
│   │   │       ├── GlobalExceptionHandler.java
│   │   │       ├── ResourceNotFoundException.java
│   │   │       ├── DailyLimitExceededException.java
│   │   │       ├── UnauthorizedException.java
│   │   │       └── DuplicateEnrollmentException.java
│   │   │
│   │   └── resources/
│   │       ├── application.yml
│   │       ├── application-dev.yml
│   │       ├── application-prod.yml
│   │       └── db/migration/
│   │           ├── V1__initial_schema.sql
│   │           ├── V2__seed_exam_types.sql
│   │           └── V3__seed_sample_questions.sql
│   │
│   └── test/
│       └── java/com/edusupernova/
│           ├── service/
│           │   ├── AuthServiceTest.java
│           │   ├── TestSessionServiceTest.java
│           │   └── DailyLimitServiceTest.java
│           └── controller/
│               ├── AuthControllerTest.java
│               └── TestSessionControllerTest.java
│
├── .env.example
├── .gitignore
├── docker-compose.yml
├── Dockerfile
├── mvnw
├── mvnw.cmd
└── pom.xml
```

---

## 9. Authentication & Security

### Token Strategy

| Token | Storage | Expiry | Purpose |
|---|---|---|---|
| Access Token (JWT) | `Authorization: Bearer` header | 15 minutes | API authentication |
| Refresh Token (JWT) | HttpOnly Secure Cookie | 7 days | Silent token refresh |

### Endpoints

| Method | Endpoint | Auth | Description |
|---|---|---|---|
| `POST` | `/auth/register` | Public | Create student account |
| `POST` | `/auth/login` | Public | Returns access token + sets cookie |
| `POST` | `/auth/refresh` | Cookie | Rotates refresh token |
| `POST` | `/auth/logout` | Bearer | Revokes refresh token |

### Role-based Access

```java
// Student-only endpoints
@PreAuthorize("hasRole('STUDENT')")

// Admin-only endpoints
@PreAuthorize("hasRole('ADMIN')")

// Both roles
@PreAuthorize("isAuthenticated()")
```

### Login Flow

```
POST /auth/login
Body: { "email": "student@test.com", "password": "••••••••" }

Response 200:
{
  "accessToken": "eyJhbG...",
  "tokenType": "Bearer",
  "expiresIn": 900,
  "user": {
    "id": 1,
    "username": "alice",
    "email": "student@test.com",
    "role": "STUDENT",
    "isPremium": false
  }
}
Set-Cookie: refreshToken=eyJhbG...; HttpOnly; Secure; SameSite=Strict; Path=/auth/refresh
```

---

## 10. API Reference

All endpoints are prefixed with `/api/v1`.

### Authentication

```
POST   /auth/register
POST   /auth/login
POST   /auth/refresh
POST   /auth/logout
```

### Exam Types & Catalogue

```
GET    /exam-types                          → List all exam types
GET    /exam-types/{id}/courses             → Courses for an exam type
GET    /courses/{id}/units                  → Units for a course (ordered)
GET    /units/{id}                          → Unit detail with summary
```

### Enrollment

```
POST   /enrollments                         → Enroll in exam type
GET    /enrollments/me                      → My enrolled exam types
DELETE /enrollments/{examTypeId}            → Unenroll
```

### Test Sessions

```
POST   /tests/start          Body: { courseId }       → Create session (checks daily limit)
GET    /tests/{sessionId}                              → Get session + questions
POST   /tests/{sessionId}/answer                       → Submit answer → AI feedback
GET    /tests/{sessionId}/report                       → Final score + all AI feedback
GET    /tests/history                                  → My past test sessions
```

### Admin Endpoints

```
POST   /admin/exam-types                    → Create exam type
PUT    /admin/exam-types/{id}               → Update exam type
DELETE /admin/exam-types/{id}               → Soft delete

POST   /admin/courses                       → Create course
PUT    /admin/courses/{id}                  → Update course
DELETE /admin/courses/{id}                  → Soft delete

POST   /admin/units                         → Create unit
PUT    /admin/units/{id}                    → Update unit (summary, order)

POST   /admin/questions                     → Create question
POST   /admin/questions/bulk               → Bulk import (JSON array)
PUT    /admin/questions/{id}                → Update question
DELETE /admin/questions/{id}                → Soft delete

GET    /admin/stats                         → Platform overview stats
```

### Example: Start a Test

```http
POST /api/v1/tests/start
Authorization: Bearer eyJhbG...
Content-Type: application/json

{
  "courseId": 3
}
```

**Response `201 Created`:**
```json
{
  "sessionId": 42,
  "courseId": 3,
  "courseName": "Pure Mathematics",
  "status": "IN_PROGRESS",
  "totalQuestions": 20,
  "currentQuestion": {
    "questionNumber": 1,
    "questionId": 117,
    "questionText": "Solve the quadratic equation x² - 5x + 6 = 0",
    "optionA": "x = 2 or x = 3",
    "optionB": "x = -2 or x = -3",
    "optionC": "x = 1 or x = 6",
    "optionD": "x = -1 or x = -6"
  }
}
```

### Example: Submit an Answer

```http
POST /api/v1/tests/42/answer
Authorization: Bearer eyJhbG...
Content-Type: application/json

{
  "questionId": 117,
  "chosenOption": "A"
}
```

**Response `200 OK`:**
```json
{
  "isCorrect": true,
  "correctOption": "A",
  "aiFeedback": "Correct! Factoring gives (x-2)(x-3)=0, so x=2 or x=3. The key is recognising two numbers that multiply to +6 and add to -5.",
  "nextQuestion": {
    "questionNumber": 2,
    "questionId": 203,
    "questionText": "...",
    "optionA": "...",
    "optionB": "...",
    "optionC": "...",
    "optionD": "..."
  },
  "sessionComplete": false
}
```

### Error Responses (RFC 7807 Problem Detail)

```json
{
  "type": "https://edusupernova.com/errors/daily-limit-exceeded",
  "title": "Daily Test Limit Reached",
  "status": 429,
  "detail": "Free users can start a maximum of 2 tests per day. Upgrade to Premium for unlimited tests.",
  "instance": "/api/v1/tests/start"
}
```

---

## 11. Daily Test Limit System

Free-tier users are limited to **2 test sessions per calendar day** (UTC). The limit is enforced at the service layer before any questions are loaded.

### How it works

1. `POST /tests/start` is called by the student
2. `DailyLimitService.checkAndIncrement(userId)` runs
3. Looks up (or creates) a row in `daily_test_counters` for `(userId, today)`
4. If `test_count >= 2` AND `is_premium = false` → throws `DailyLimitExceededException` → HTTP 429
5. Otherwise, increments counter atomically and proceeds

### Key service code

```java
@Transactional
public void checkAndIncrement(Long userId, boolean isPremium) {
    if (isPremium) return; // no limit for premium

    LocalDate today = LocalDate.now(ZoneOffset.UTC);
    DailyTestCounter counter = repository
        .findByUserIdAndTestDate(userId, today)
        .orElseGet(() -> DailyTestCounter.builder()
            .userId(userId)
            .testDate(today)
            .testCount(0)
            .build());

    if (counter.getTestCount() >= FREE_DAILY_LIMIT) {
        throw new DailyLimitExceededException(
            "You have reached your daily limit of %d tests. Upgrade to Premium for unlimited access."
                .formatted(FREE_DAILY_LIMIT));
    }

    counter.setTestCount(counter.getTestCount() + 1);
    repository.save(counter);
}
```

---

## 12. Groq AI Integration

EduSupernova uses **Groq's `llama3-8b-8192`** model for sub-second per-question feedback.

### Configuration

```yaml
app:
  groq:
    api-key: ${GROQ_API_KEY}
    model: llama3-8b-8192
    base-url: https://api.groq.com/openai/v1
```

### GroqFeedbackService

The service is called immediately after each answer submission. It sends the question, all options, the student's choice, and the correct answer to Groq, and returns a brief pedagogical explanation.

**Prompt template:**

```
You are a concise exam tutor. A student answered a multiple-choice question.
Question: {questionText}
Options: A) {optA}  B) {optB}  C) {optC}  D) {optD}
Student answered: {chosenOption}
Correct answer: {correctOption}

Provide a 2-3 sentence explanation that:
1. States whether they were correct or not.
2. Explains WHY the correct answer is right.
3. Gives a quick memory tip if relevant.
Be encouraging and direct. Do not repeat the question.
```

### Timeout & Fallback

- HTTP timeout: 8 seconds
- If Groq is unavailable, the answer is still saved and feedback defaults to the stored `explanation` field from the `questions` table
- Errors are logged but never bubble up to the student as a 500

---

## 13. Running Tests

```bash
# Unit tests only
mvn test

# Integration tests (requires Docker for Testcontainers)
mvn verify -P integration-tests

# Generate coverage report
mvn jacoco:report
# Open: target/site/jacoco/index.html
```

### Test categories

| Annotation | Scope |
|---|---|
| `@SpringBootTest` | Full context integration tests |
| `@WebMvcTest` | Controller slice (no DB) |
| `@DataJpaTest` | Repository slice (Testcontainers MySQL) |
| Plain JUnit 5 | Service unit tests with Mockito |

---

## 14. Docker Deployment

### Development (docker-compose)

```yaml
# docker-compose.yml
version: '3.9'
services:
  mysql:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: edusupernova
      MYSQL_USER: edusupernova_user
      MYSQL_PASSWORD: secret
    ports:
      - "3306:3306"
    volumes:
      - mysql_data:/var/lib/mysql

  api:
    build: .
    ports:
      - "8080:8080"
    environment:
      DB_USERNAME: edusupernova_user
      DB_PASSWORD: secret
      JWT_SECRET: ${JWT_SECRET}
      GROQ_API_KEY: ${GROQ_API_KEY}
    depends_on:
      mysql:
        condition: service_healthy

volumes:
  mysql_data:
```

```bash
# Start everything
docker-compose up -d

# View logs
docker-compose logs -f api

# Stop
docker-compose down
```

### Production Dockerfile

```dockerfile
FROM eclipse-temurin:21-jre-alpine AS runtime
WORKDIR /app
COPY target/edusupernova-*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "-Dspring.profiles.active=prod", "app.jar"]
```

```bash
mvn clean package -DskipTests
docker build -t edusupernova-api:latest .
```

---

## 15. Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/my-feature`
3. Follow the existing code style (Checkstyle config in `checkstyle.xml`)
4. Write tests for all new service-layer logic
5. Open a Pull Request against `develop`

### Code Style Rules

- No business logic in controllers — delegate to `@Service`
- Use **record DTOs** for all request/response objects
- All `@Service` public methods must be `@Transactional` where DB writes occur
- Never expose `@Entity` objects directly from controller methods
- All endpoints must be documented with `@Operation` (SpringDoc/OpenAPI)

---

## License

MIT © EduSupernova Team

---

<p align="center">
  <b>EduSupernova</b> · Learn. Dominate. Shine. 🦚
</p>