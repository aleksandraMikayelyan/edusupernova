# EduSupernova — Backend API

> **"Learn. Dominate. Shine."**
> AI-powered exam preparation platform — Spring Boot 3.3 REST API

[![Java](https://img.shields.io/badge/Java-21-orange?logo=openjdk)](https://openjdk.org/projects/jdk/21/)
[![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.3.5-brightgreen?logo=springboot)](https://spring.io/projects/spring-boot)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-Supabase-blue?logo=postgresql)](https://supabase.com/)
[![JWT](https://img.shields.io/badge/JWT-Auth-yellow?logo=jsonwebtokens)](https://jwt.io/)
[![Groq](https://img.shields.io/badge/Groq-llama--3.3--70b-purple)](https://groq.com/)
[![Docker](https://img.shields.io/badge/Docker-Render-blue?logo=docker)](https://render.com/)

---

## Table of Contents

1. [Project Overview](#1-project-overview)
2. [Tech Stack](#2-tech-stack)
3. [Architecture](#3-architecture)
4. [Prerequisites](#4-prerequisites)
5. [Getting Started](#5-getting-started)
6. [Environment Variables](#6-environment-variables)
7. [Database](#7-database)
8. [Project Structure](#8-project-structure)
9. [Authentication & Security](#9-authentication--security)
10. [API Reference](#10-api-reference)
11. [AI Evaluation System](#11-ai-evaluation-system)
12. [Docker & Deployment](#12-docker--deployment)

---

## 1. Project Overview

EduSupernova is a freemium AI-powered exam preparation platform targeting **A Levels / AS Levels, SAT, IELTS, ACT, and TOEFL** students. This repository contains the **Spring Boot 3.3 backend** which powers:

- **JWT Authentication** — stateless access tokens + Google OAuth2 sign-in
- **Exam & Question Management** — Exam → Course → Paper → Unit → Question hierarchy
- **Randomised Tests** — questions drawn per paper with group/passage support
- **Instant AI Feedback** — open-ended answers evaluated by Groq's `llama-3.3-70b-versatile` with exam-specific rubrics (IELTS bands, SAT dimensions, A Level AOs, etc.)
- **Test History & Progress** — per-user completed test tracking and replay
- **Admin Panel API** — question CRUD, question groups (passages), formula sheet uploads
- **Formula Sheet Serving** — PDF download endpoint per course

---

## 2. Tech Stack

| Layer | Technology |
|---|---|
| Language | Java 21 (Virtual Threads enabled) |
| Framework | Spring Boot 3.3.5 |
| Security | Spring Security 6 + JJWT |
| Persistence | Spring Data JPA + Hibernate 6 |
| Database | PostgreSQL via Supabase |
| AI Integration | Groq API (`llama-3.3-70b-versatile`) |
| Build Tool | Maven 3.9+ |
| Containerisation | Docker (multi-stage build) |
| Deployment | Render (free tier) |
| Frontend | React + Vite → Vercel (`edu-supernova.com`) |

---

## 3. Architecture

```
┌──────────────────────────────────────────────────────┐
│                  Presentation Layer                  │
│   @RestController · Record DTOs · GlobalExceptionHandler │
├──────────────────────────────────────────────────────┤
│                  Application Layer                   │
│        @Service · TestService · OpenEndedEvaluator   │
├──────────────────────────────────────────────────────┤
│                   Domain Layer                       │
│   @Entity · Tests · Quiz · QuestionGroup · Unit      │
├──────────────────────────────────────────────────────┤
│                Infrastructure Layer                  │
│   @Repository · GroqService · Spring Security · JPA  │
└──────────────────────────────────────────────────────┘
```

**Key design decisions:**

- **Virtual Threads** for high concurrency with zero thread-pool tuning
- **Record DTOs** for immutable request/response objects
- **Exam-specific AI rubrics** — IELTS, TOEFL, SAT, A Level, ACT each have their own scoring criteria injected into the Groq prompt
- **Autosave idempotency** — re-submitting an already-evaluated answer reuses the cached score instead of calling Groq again
- **Completion batch evaluation** — any open-ended question answered but not yet scored is evaluated in a single Groq batch call when the test completes
- **CORS restricted** to `edu-supernova.com` and localhost for development

---

## 4. Prerequisites

| Tool | Minimum Version |
|---|---|
| JDK | 21 (LTS) |
| Maven | 3.9+ |
| Docker | 24+ (for deployment) |
| PostgreSQL | Via Supabase (cloud) |

---

## 5. Getting Started

### Clone and install

```bash
git clone https://github.com/your-org/edusupernova-backend.git
cd edusupernova-backend/EduSuperNova
```

### Run locally

```bash
# Copy the example env and fill in your values
cp .env.example .env

# Start Spring Boot (reads from .env)
./mvnw spring-boot:run
```

Server starts on **`http://localhost:8080`**.

> The schema is managed manually via Supabase SQL editor — `spring.jpa.hibernate.ddl-auto=validate` means Hibernate validates but never modifies the schema.

---

## 6. Environment Variables

Create a `.env` file in `EduSuperNova/` (never commit it):

```dotenv
# ── Database (Supabase PostgreSQL) ──────────────────────
DB_URL=jdbc:postgresql://db.xxxx.supabase.co:5432/postgres
DB_USERNAME=postgres
DB_PASSWORD=your_supabase_password

# ── JWT ─────────────────────────────────────────────────
JWT_SECRET=your_256bit_secret_here

# ── Groq AI ─────────────────────────────────────────────
GROQ_API_KEY=gsk_xxxxxxxxxxxxxxxxxxxx

# ── Google OAuth2 ────────────────────────────────────────
GOOGLE_CLIENT_ID=xxxx.apps.googleusercontent.com

# ── Mail (SMTP) ──────────────────────────────────────────
MAIL_HOST=smtp.gmail.com
MAIL_PORT=587
MAIL_USERNAME=your@gmail.com
MAIL_PASSWORD=your_app_password

# ── File Storage ─────────────────────────────────────────
# Local dev:
UPLOAD_DIR=C:/images/
# On Render (set automatically):
# UPLOAD_DIR=/app/uploads/

# ── Render (set automatically by platform) ───────────────
# PORT=10000
```

### Render Environment Variables

Set all of the above in **Render → Service → Environment** (no `.env` file needed in production). Render automatically injects `PORT`.

---

## 7. Database

**Database:** PostgreSQL hosted on [Supabase](https://supabase.com/)

### Schema Overview

```
Exams
 └── Courses  (section: AS | A2 | null)
       └── Papers  (format: MCQ | ESSAY | IELTS_WRITING | DATA_RESPONSE | …)
             ├── question_groups  (passage/extract + contextText)
             │     └── Quizes  (questions linked to a group)
             └── Quizes  (standalone questions, no group)
       └── Units  (ordered study material, summary_path → classpath .txt)

Users
 └── Tests  (status: IN_PROGRESS | COMPLETED | ABANDONED)
       └── Test_Question  (composite PK: testId + quizId)
             └── aiScore, feedbackIa, userResponse, answeredAt

Enrollments  (user ↔ exam)
```

### Seeding

SQL seed files live in `src/main/resources/db/`. Run them in the Supabase SQL editor:

```
seed_act.sql
seed_act_english.sql
seed_act_reading_questions.sql
seed_act_math_questions.sql
seed_act_math_questions_ext.sql
seed_ielts_reading.sql
seed_ielts_listening.sql
seed_ielts_writing.sql
seed_sat.sql
seed_asLevel_paper1.sql
seed_asLevel_english_units.sql
seed_a2Level_courses.sql
```

---

## 8. Project Structure

```
EduSuperNova/
├── src/main/
│   ├── java/com/edusupernova/edusupernova/
│   │   ├── config/
│   │   │   ├── SecurityConfig.java       # CORS + JWT filter chain
│   │   │   └── JwtAuthenticationFilter.java
│   │   ├── controller/
│   │   │   ├── AdminController.java      # Questions, groups, formula sheets
│   │   │   ├── CourseController.java     # Course list + formula sheet download
│   │   │   ├── ExamController.java       # Exam discovery + enrollment
│   │   │   ├── TestController.java       # Start / answer / report / history
│   │   │   ├── UnitController.java       # Units screen data
│   │   │   ├── ProgressController.java   # Progress + completed groups
│   │   │   └── UserController.java       # Register / login / Google OAuth
│   │   ├── service/
│   │   │   ├── TestService.java          # Core test lifecycle
│   │   │   ├── OpenEndedEvaluator.java   # Exam-specific Groq rubrics
│   │   │   ├── GroqService.java          # HTTP client for Groq API
│   │   │   ├── QuizService.java          # Question selection / generation
│   │   │   └── …
│   │   ├── model/                        # JPA entities
│   │   ├── dto/request/ + dto/response/  # Record DTOs
│   │   ├── data/                         # Spring Data JPA repositories
│   │   └── exception/                    # GlobalExceptionHandler
│   └── resources/
│       ├── application.properties
│       ├── Summaries/                    # Unit .txt content files
│       │   ├── ALevels/Economy/…
│       │   ├── ALevels/Math/…
│       │   ├── ALevels/English/…
│       │   ├── ACT/…
│       │   ├── SAT/…
│       │   ├── ielts/…
│       │   └── toefl/…
│       └── db/                           # SQL seed files
├── dockerfile                            # Multi-stage Docker build
├── pom.xml
└── mvnw / mvnw.cmd
```

---

## 9. Authentication & Security

### Token Strategy

| Token | Storage | Purpose |
|---|---|---|
| JWT Access Token | `Authorization: Bearer` header | API authentication, stateless |

Tokens are held in-memory on the frontend (never localStorage). On page refresh the user re-authenticates.

### Allowed Origins (CORS)

```
https://edu-supernova.com
https://www.edu-supernova.com
http://localhost:5173   (Vite dev)
http://localhost:3000   (alt dev)
```

### Login Flow

```http
POST /api/users/login
Content-Type: application/json

{ "email": "student@test.com", "password": "••••••••" }
```

```json
{
  "accessToken": "eyJhbG...",
  "tokenType": "Bearer",
  "expiresIn": 86400,
  "rol": "STUDENT",
  "user": { "id": 1, "username": "alice", "email": "student@test.com" }
}
```

---

## 10. API Reference

All endpoints are prefixed with `/api`.

### Auth

| Method | Endpoint | Auth | Description |
|---|---|---|---|
| `POST` | `/users/register` | Public | Create account |
| `POST` | `/users/login` | Public | Returns JWT |
| `POST` | `/users/google-auth` | Public | Google OAuth sign-in |

### Exams & Courses

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/exams/dashboard` | All active exams |
| `GET` | `/exams/{examId}` | Courses for an exam |
| `GET` | `/units/course/{courseId}` | Units + papers for a course |
| `GET` | `/courses/{courseId}/formula-sheet` | Download formula PDF |

### Tests

| Method | Endpoint | Description |
|---|---|---|
| `POST` | `/tests/start` | Start a test session |
| `POST` | `/tests/{testId}/answer` | Submit answer → AI feedback |
| `GET` | `/tests/{testId}/report` | Final report with AI scores |
| `GET` | `/tests/{testId}/questions` | All questions for a test |
| `GET` | `/tests/history` | User's completed test history |

### Admin

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/admin/exams` | All exams (for selectors) |
| `GET` | `/admin/exams/{examId}/courses` | Courses + papers |
| `GET` | `/admin/papers/{paperId}/groups` | Question groups |
| `POST` | `/admin/groups` | Create a passage/group |
| `POST` | `/admin/questions` | Add a question |
| `DELETE` | `/admin/questions/{id}` | Delete a question |
| `POST` | `/admin/courses/{courseId}/formula-sheet` | Upload PDF |

---

## 11. AI Evaluation System

Open-ended answers (essays, IELTS writing, data response) are evaluated by **Groq's `llama-3.3-70b-versatile`** using exam-specific rubrics.

### Exam Rubrics

| Exam | Criteria | Native Scale → 0–10 |
|---|---|---|
| IELTS Writing | Task Achievement, Coherence & Cohesion, Lexical Resource, Grammatical Range | Band × 1.11 |
| TOEFL Writing | Development, Organization, Language Use | Score × 2 |
| SAT Essay | Reading, Analysis, Writing (each 1–4) | (sum−3)/9 × 10 |
| A Level / AS Level | AO1 Knowledge, AO2 Application, AO3 Analysis, QWC | 0–10 (A*=8+) |
| ACT Writing | Ideas, Development, Organization, Language (each 1–6) | (avg−1)/5 × 10 |

### Feedback Structure

The AI returns structured JSON feedback with three sections:

```json
{
  "strengths": "Clear position and well-developed argument.",
  "criteria": {
    "Lexical Resource": "Vocabulary is repetitive — 'important' appears 4 times. Use 'significant', 'critical', or 'pivotal'.",
    "Coherence & Cohesion": "Paragraph transitions are abrupt. Add bridging sentences between ideas."
  },
  "nextSteps": "1. Build a vocabulary log. 2. Practice cohesive devices."
}
```

### Idempotency

Re-submitting an already-evaluated answer reuses the cached score — Groq is not called again. This prevents race conditions from autosave hooks and duplicate submits.

---

## 12. Docker & Deployment

### Dockerfile (multi-stage)

```dockerfile
# Stage 1: Build
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline -q
COPY src ./src
RUN mvn package -DskipTests -q

# Stage 2: Runtime (~90 MB)
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
RUN mkdir -p /app/uploads/formula-sheets
COPY --from=build /app/target/edusupernova-0.0.1-SNAPSHOT.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
```

### Deploy to Render

1. Push this repo to GitHub
2. Render → **New Web Service** → Docker → connect repo
3. Set environment variables in Render dashboard (see §6)
4. Render auto-builds on every push to `main`
5. Public URL: `https://edusupernova.onrender.com`

### Frontend (Vercel)

The React frontend lives in a separate repo and is deployed to Vercel at **`https://edu-supernova.com`**.

In dev, Vite proxies `/api/*` to `localhost:8080`. In production, `VITE_API_URL=https://edusupernova.onrender.com` points directly at the Render backend.

---

## License

MIT © EduSupernova Team

---

<p align="center">
  <b>EduSupernova</b> · Learn. Dominate. Shine.
</p>
