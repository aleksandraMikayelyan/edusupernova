package com.edusupernova.edusupernova.service;

import com.edusupernova.edusupernova.data.*;
import com.edusupernova.edusupernova.dto.request.StartTestRequest;
import com.edusupernova.edusupernova.dto.request.SubmitAnswerRequest;
import com.edusupernova.edusupernova.dto.response.AnswerFeedbackDTO;
import com.edusupernova.edusupernova.dto.response.FeedBackDTO;
import com.edusupernova.edusupernova.dto.response.TestQuestionDTO;
import com.edusupernova.edusupernova.dto.response.TestSessionDTO;
import com.edusupernova.edusupernova.exception.ForbiddenException;
import com.edusupernova.edusupernova.exception.ResourceNotFoundException;
import com.edusupernova.edusupernova.model.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 * Manages the full lifecycle of a student test:
 *
 *   1. startTest()     — create session, pick questions from Paper+Unit pool
 *   2. submitAnswer()  — evaluate one answer, return AI feedback + next question
 *   3. getSession()    — resume an in-progress test (reload on refresh)
 *   4. getReport()     — final score breakdown after completion
 *
 * CHANGED FROM ORIGINAL:
 *   - createTest/createTestByEmail merged into startTest(StartTestRequest, email)
 *   - Question selection delegated to QuizService.generateTestForPaper (Paper+Unit aware)
 *   - saveAnswers() replaced by per-question submitAnswer() for instant feedback
 *   - Timer: timeLimitMinutes comes from Paper or falls back to Exam
 *   - Tests now tracks status (IN_PROGRESS → COMPLETED), completedAt, finalScore
 */
@Slf4j
@Service
@RequiredArgsConstructor
@Transactional
public class TestService {

    // ── Dependencies ─────────────────────────────────────────────────────────

    private final TestRepository          testRepository;
    private final TestQuestionsRepository testQuestionsRepository;
    private final UserRepository          userRepository;
    private final CourseRepository        courseRepository;
    private final PaperRepository         paperRepository;
    private final UnitRepository          unitRepository;
    private final QuizRepository          quizRepository;
    private final QuizService             quizService;
    private final GroqService             groqService;
    private final OpenEndedEvaluator      openEndedEvaluator;

    // ── 1. START TEST ─────────────────────────────────────────────────────────

    /**
     * Creates a new test session for a specific Paper, optionally filtered to a Unit.
     *
     * Flow:
     *   1. Resolve user from JWT email
     *   2. Load Paper (defines format, totalQuestions, timeLimitMinutes)
     *   3. Optionally load Unit (for "Paper 1 — Unit 1 only" mode)
     *   4. Pick randomised questions via QuizService
     *   5. Persist Tests + TestQuestions rows
     *   6. Return TestSessionDTO with first question
     *
     * @param request StartTestRequest with courseId, paperId, optional unitId
     * @param email   extracted from JWT in the controller — never from request body
     */
    public TestSessionDTO startTest(StartTestRequest request, String email) {
        Users   user   = findUserByEmail(email);
        Courses course = findCourse(request.courseId());
        Paper   paper  = request.paperId() != null
                ? findPaper(request.paperId())
                : findFirstPaperForCourse(request.courseId());
        Unit    unit   = request.unitId() != null ? findUnit(request.unitId()) : null;

        // Resolve time limit: Paper overrides Exam default
        int timeLimitMinutes = paper.getTimeLimitMinutes() != null
                ? paper.getTimeLimitMinutes()
                : course.getExam().getTimeLimitMinutes();

        // Build and persist the test entity
        Tests test = new Tests();
        test.setUser(user);
        test.setCourse(course);
        test.setPaper(paper);
        test.setUnit(unit);
        test.setStatus(Tests.TestStatus.IN_PROGRESS);
        test.setCreationDate(LocalDateTime.now());
        test.setStartedAt(LocalDateTime.now());
        test.setTimeLimitMinutes(timeLimitMinutes);
        Tests saved = testRepository.save(test);

        // Pick questions — behaviour depends on whether a specific group was requested
        List<Quiz> questions;

        if (request.forceGroupId() != null) {
            // "Practice again" path: use only the requested QuestionGroup, ignore exclusions
            questions = quizRepository.findByQuestionGroupId(request.forceGroupId());
            questions.sort(java.util.Comparator.comparingInt(
                    q -> q.getGroupOrderIndex() != null ? q.getGroupOrderIndex() : 0));
            log.info("startTest forceGroupId={} → {} questions", request.forceGroupId(), questions.size());
        } else {
            // Normal path: exclude groups the user has already completed for this paper
            Set<Integer> doneGroupIds = new HashSet<>(
                    testQuestionsRepository.findCompletedGroupIdsByUserAndPaper(
                            user.getId(), paper.getId()));
            log.info("startTest paperId={} userId={} doneGroups={}", paper.getId(), user.getId(), doneGroupIds);
            questions = quizService.generateTestForPaper(
                    paper, request.unitId(), paper.getTotalQuestions(), doneGroupIds);
        }

        if (questions.isEmpty()) {
            throw new IllegalStateException(
                    "No questions available for paperId=" + paper.getId()
                            + (unit != null ? " unitId=" + unit.getId() : ""));
        }

        // Persist placeholder TestQuestions rows (unanswered)
        List<TestQuestions> testQuestions = questions.stream()
                .map(quiz -> buildTestQuestion(saved, quiz))
                .toList();
        testQuestionsRepository.saveAll(testQuestions);

        log.info("Started testId={} userId={} paperId={} unitId={} questions={}",
                saved.getId(), user.getId(), paper.getId(),
                unit != null ? unit.getId() : "all", testQuestions.size());

        return toSessionDTO(saved, testQuestions, paper, unit, timeLimitMinutes);
    }

    // ── 2. SUBMIT ANSWER ──────────────────────────────────────────────────────

    /**
     * Evaluates a single answer and returns immediate feedback + the next question.
     *
     * For MCQ / TRUE_FALSE_NG / NUMERIC_INPUT:
     *   - Evaluated instantly by comparing to correctAnswer column
     *   - Groq called for a brief explanation (or falls back to stored explanation)
     *
     * For ESSAY / OPEN_ENDED:
     *   - Evaluated by OpenEndedEvaluator (Groq batch call)
     *   - aiScore populated (0-10)
     *
     * @param testId  the active test session
     * @param request quizId + userResponse
     * @param email   from JWT — used to verify ownership
     */
    public AnswerFeedbackDTO submitAnswer(Integer testId, SubmitAnswerRequest request, String email) {
        Tests test = findTest(testId);
        assertOwnership(test, email);
        assertNotExpired(test);

        // Find the matching TestQuestion row
        TestQuestions tq = testQuestionsRepository
                .findByIdTestIdAndIdQuizId(testId, request.quizId())
                .orElseThrow(() -> new IllegalArgumentException(
                        "Question quizId=" + request.quizId() + " not in testId=" + testId));

        Quiz quiz = tq.getQuiz();
        boolean isMCQ = isMCQType(quiz.getQuestionType());

        // ── Evaluate ─────────────────────────────────────────────────────────
        boolean  isCorrect;
        String   aiFeedback;
        Double   aiScore = null;

        // Set the response on tq before evaluation so the AI sees the actual answer
        tq.setUserResponse(request.userResponse());

        if (isMCQ) {
            isCorrect  = evaluateMCQ(request.userResponse(), quiz.getCorrectAnswer());
            aiFeedback = generateMCQFeedback(quiz, isCorrect);
        } else {
            // ESSAY / OPEN_ENDED — single-question AI evaluation
            try {
                OpenEndedEvaluator.EvaluationResult result =
                        openEndedEvaluator.evaluateBatch(List.of(tq),
                                buildContext(test)).get(0);
                isCorrect  = result.score() >= 6.0;
                aiFeedback = result.feedback();
                aiScore    = result.score();
            } catch (RuntimeException e) {
                log.warn("AI evaluation failed for quizId={}: {}", request.quizId(), e.getMessage());
                isCorrect  = false;
                aiFeedback = "AI feedback unavailable — please review your answer manually.";
                aiScore    = -1.0;
            }
        }

        // ── Persist answer ────────────────────────────────────────────────────
        tq.setCorrectResponse(isCorrect);
        tq.setFeedbackIa(aiFeedback);
        tq.setAiScore(aiScore);
        tq.setAnsweredAt(LocalDateTime.now());
        testQuestionsRepository.save(tq);

        // ── Update test totals ────────────────────────────────────────────────
        test.setTotalAnswered(test.getTotalAnswered() + 1);
        if (isCorrect) test.setTotalCorrect(test.getTotalCorrect() + 1);

        // ── Check completion ──────────────────────────────────────────────────
        List<TestQuestions> allQuestions = testQuestionsRepository.findByIdTestId(testId);
        long unanswered = allQuestions.stream()
                .filter(q -> q.getUserResponse() == null || q.getUserResponse().isBlank())
                .count();

        boolean complete = unanswered == 0;

        if (complete) {
            int correctCount = (int) allQuestions.stream()
                    .filter(q -> Boolean.TRUE.equals(q.getCorrectResponse()))
                    .count();
            test.setTotalCorrect(correctCount);
            test.setTotalAnswered(allQuestions.size());
            test.setStatus(Tests.TestStatus.COMPLETED);
            test.setCompletedAt(LocalDateTime.now());
            test.setFinalScore(calculatePercentage(correctCount, allQuestions.size()));
        }
        testRepository.save(test);

        // ── Find next unanswered question ─────────────────────────────────────
        TestQuestionDTO nextQuestion = null;
        if (!complete) {
            nextQuestion = allQuestions.stream()
                    .filter(q -> q.getUserResponse() == null || q.getUserResponse().isBlank())
                    .findFirst()
                    .map(q -> toQuestionDTO(q, getQuestionNumber(allQuestions, q)))
                    .orElse(null);
        }

        log.debug("testId={} quizId={} correct={} complete={}", testId, request.quizId(), isCorrect, complete);

        return new AnswerFeedbackDTO(
                quiz.getId(),
                isCorrect,
                quiz.getCorrectAnswer(),
                quiz.getExplanation(),
                aiFeedback,
                aiScore,
                complete,
                nextQuestion
        );
    }

    // ── 3. GET SESSION ────────────────────────────────────────────────────────

    /**
     * Returns the current state of a test session.
     * Used to restore state after a page refresh.
     *
     * @throws IllegalArgumentException if test not found
     */
    @Transactional(readOnly = true)
    public TestSessionDTO getSession(Integer testId, String email) {
        Tests test = findTest(testId);
        assertOwnership(test, email);

        List<TestQuestions> allQuestions = testQuestionsRepository.findByIdTestId(testId);
        int timeLimitMinutes = test.getTimeLimitMinutes();

        return toSessionDTO(test, allQuestions, test.getPaper(), test.getUnit(), timeLimitMinutes);
    }

    // ── 4. REPORT ─────────────────────────────────────────────────────────────

    /**
     * Builds the final report shown on the FeedbackPage.
     * All questions including AI feedback are included.
     */
    @Transactional(readOnly = true)
    public FeedBackDTO getReport(Integer testId, String email) {
        Tests test = findTest(testId);
        assertOwnership(test, email);

        List<TestQuestions> allQuestions = testQuestionsRepository.findByIdTestId(testId);
        int total = allQuestions.size();

        long durationSeconds = test.getCompletedAt() != null
                ? ChronoUnit.SECONDS.between(test.getStartedAt(), test.getCompletedAt())
                : 0L;

        List<FeedBackDTO.QuestionFeedbackDTO> questionFeedback = allQuestions.stream()
                .map(tq -> toQuestionFeedbackDTO(tq, getQuestionNumber(allQuestions, tq)))
                .toList();

        double finalScore = calculatePercentage(test.getTotalCorrect(), total);
        String grade = calculateGrade(finalScore);

        return new FeedBackDTO(
                test.getId(),
                test.getCourse().getCoursename(),
                test.getPaper() != null ? test.getPaper().getPaperName() : null,
                test.getUnit()  != null ? test.getUnit().getTitle()      : null,
                test.getTotalCorrect(),
                total,
                finalScore,
                grade,
                test.getStartedAt(),
                test.getCompletedAt(),
                durationSeconds,
                questionFeedback
        );
    }

    // ── Timer ─────────────────────────────────────────────────────────────────

    /**
     * Remaining seconds before the test session expires.
     * Returns 0 if already expired.
     */
    public long getRemainingSeconds(Tests test) {
        if (test.getStartedAt() == null || test.getTimeLimitMinutes() == null) return 0L;
        LocalDateTime expiresAt = test.getStartedAt().plusMinutes(test.getTimeLimitMinutes());
        long remaining = ChronoUnit.SECONDS.between(LocalDateTime.now(), expiresAt);
        return Math.max(0L, remaining);
    }

    // ── Private — evaluation helpers ──────────────────────────────────────────

    private boolean evaluateMCQ(String userResponse, String correctAnswer) {
        String user    = extractLetter(userResponse);
        String correct = extractLetter(correctAnswer);
        return !user.isBlank() && user.equalsIgnoreCase(correct);
    }

    /**
     * Calls Groq for a brief MCQ explanation.
     * Falls back to the stored explanation if Groq is unavailable.
     */
    private String generateMCQFeedback(Quiz quiz, boolean isCorrect) {
        String prefix = isCorrect ? "Correct! " : "Incorrect. ";
        if (quiz.getExplanation() != null && !quiz.getExplanation().isBlank()) {
            return prefix + quiz.getExplanation();
        }
        return isCorrect
                ? "Correct!"
                : "Incorrect. The correct answer was: " + quiz.getCorrectAnswer();
    }

    private boolean isMCQType(Quiz.QuestionType type) {
        return switch (type) {
            case MULTIPLE_CHOICE, TRUE_FALSE_NG, NUMERIC_INPUT -> true;
            default -> false;
        };
    }

    private String buildContext(Tests test) {
        return String.format("Exam: %s, Paper: %s",
                test.getCourse().getExam().getExamname(),
                test.getPaper() != null ? test.getPaper().getPaperName() : "General");
    }

    /**
     * Extracts leading answer letter — handles "D) full text..." and bare "D" formats.
     */
    private String extractLetter(String response) {
        if (response == null || response.isBlank()) return "";
        String trimmed = response.trim();
        java.util.regex.Matcher m =
                java.util.regex.Pattern.compile("^([A-Da-d])[).\\s]").matcher(trimmed);
        return m.find() ? m.group(1).toUpperCase() : trimmed.toUpperCase();
    }

    private double calculatePercentage(int correct, int total) {
        return total > 0 ? Math.round((correct * 100.0) / total * 100.0) / 100.0 : 0.0;
    }

    private String calculateGrade(double percentage) {
        if (percentage >= 90) return "A*";
        if (percentage >= 80) return "A";
        if (percentage >= 70) return "B";
        if (percentage >= 60) return "C";
        if (percentage >= 50) return "D";
        return "U";
    }

    // ── Private — persistence helpers ─────────────────────────────────────────

    private TestQuestions buildTestQuestion(Tests test, Quiz quiz) {
        TestQuestionId id = new TestQuestionId(test.getId(), quiz.getId());

        TestQuestions tq = new TestQuestions();
        tq.setId(id);
        tq.setTest(test);
        tq.setQuiz(quiz);
        tq.setCorrectResponse(false);
        return tq;
    }

    // ── Private — finders ─────────────────────────────────────────────────────

    private Users findUserByEmail(String email) {
        Users user = userRepository.findByEmail(email);
        if (user == null) throw new IllegalArgumentException("User not found: " + email);
        return user;
    }

    private Courses findCourse(Integer courseId) {
        return courseRepository.findById(courseId)
                .orElseThrow(() -> new IllegalArgumentException("Course not found: " + courseId));
    }

    private Paper findPaper(Integer paperId) {
        return paperRepository.findById(paperId)
                .orElseThrow(() -> new IllegalArgumentException("Paper not found: " + paperId));
    }

    private Paper findFirstPaperForCourse(Integer courseId) {
        List<Paper> papers = paperRepository.findByCourseIdOrderByOrderIndex(courseId);
        if (papers.isEmpty())
            throw new IllegalStateException("No papers found for courseId=" + courseId);
        return papers.get(0);
    }

    private Unit findUnit(Integer unitId) {
        return unitRepository.findById(unitId)
                .orElseThrow(() -> new IllegalArgumentException("Unit not found: " + unitId));
    }

    private Tests findTest(Integer testId) {
        return testRepository.findById(testId)
                .orElseThrow(() -> new ResourceNotFoundException("Test not found: " + testId));
    }

    private void assertOwnership(Tests test, String email) {
        if (!test.getUser().getEmail().equals(email)) {
            throw new ForbiddenException("Test does not belong to user: " + email);
        }
    }

    private void assertNotExpired(Tests test) {
        if (getRemainingSeconds(test) == 0 && test.getStatus() == Tests.TestStatus.IN_PROGRESS) {
            test.setStatus(Tests.TestStatus.ABANDONED);
            testRepository.save(test);
            throw new IllegalStateException("Test time limit exceeded");
        }
    }

    // ── Private — DTO mappers ─────────────────────────────────────────────────

    private TestSessionDTO toSessionDTO(
            Tests test,
            List<TestQuestions> allQuestions,
            Paper paper,
            Unit unit,
            int timeLimitMinutes) {

        // Find first unanswered question
        TestQuestionDTO currentQuestion = allQuestions.stream()
                .filter(q -> q.getUserResponse() == null || q.getUserResponse().isBlank())
                .findFirst()
                .map(q -> toQuestionDTO(q, getQuestionNumber(allQuestions, q)))
                .orElse(null);

        long remainingSeconds = getRemainingSeconds(test);

        return new TestSessionDTO(
                test.getId(),
                test.getCourse().getCoursename(),
                paper  != null ? paper.getPaperName()  : null,
                paper  != null ? paper.getFormat().name() : null,
                unit   != null ? unit.getTitle()        : null,
                allQuestions.size(),
                (int) allQuestions.stream().filter(q -> q.getUserResponse() != null
                        && !q.getUserResponse().isBlank()).count(),
                test.getTotalCorrect(),
                test.getStatus().name(),
                test.getStartedAt(),
                timeLimitMinutes,
                remainingSeconds,
                currentQuestion
        );
    }

    private TestQuestionDTO toQuestionDTO(TestQuestions tq, int questionNumber) {
        Quiz quiz = tq.getQuiz();
        QuestionGroup group = quiz.getQuestionGroup();
        return new TestQuestionDTO(
                tq.getId().getTestId(),
                quiz.getId(),
                questionNumber,
                quiz.getQuestionText(),
                quiz.getQuestionType().name(),
                quiz.getDifficulty() != null ? quiz.getDifficulty().name() : "MEDIUM",
                quiz.getOptionA(),
                quiz.getOptionB(),
                quiz.getOptionC(),
                quiz.getOptionD(),
                quiz.getOptionE(),
                tq.getUserResponse(),
                tq.getCorrectResponse(),
                tq.getFeedbackIa(),
                // group context — null for standalone MCQ questions
                group != null ? group.getId()              : null,
                group != null ? group.getTitle()           : null,
                group != null ? group.getContextText()     : null,
                group != null ? group.getContextImageUrl() : null,
                quiz.getGroupOrderIndex(),
                quiz.getMarks()
        );
    }

    private FeedBackDTO.QuestionFeedbackDTO toQuestionFeedbackDTO(TestQuestions tq, int questionNumber) {
        Quiz quiz = tq.getQuiz();
        return new FeedBackDTO.QuestionFeedbackDTO(
                questionNumber,
                quiz.getId(),
                quiz.getQuestionText(),
                quiz.getQuestionType().name(),
                tq.getUserResponse(),
                quiz.getCorrectAnswer(),
                tq.getCorrectResponse(),
                quiz.getExplanation(),
                tq.getFeedbackIa(),
                tq.getAiScore()
        );
    }

    private int getQuestionNumber(List<TestQuestions> all, TestQuestions target) {
        return all.indexOf(target) + 1;
    }

    // ── Compatibility methods (used by legacy TestController / FeedbackController) ──

    /**
     * Batch-saves user responses for a list of TestQuestions.
     * Used by the legacy submit flow in TestController and FeedbackController.
     */
    @Transactional
    public boolean saveAnswers(Integer testId, List<TestQuestions> userAnswers) {
        try {
            userAnswers.forEach(ua -> {
                if (ua.getId() != null && ua.getId().getQuizId() != null) {
                    testQuestionsRepository
                            .findByIdTestIdAndIdQuizId(testId, ua.getId().getQuizId())
                            .ifPresent(tq -> {
                                tq.setUserResponse(ua.getUserResponse());
                                testQuestionsRepository.save(tq);
                            });
                }
            });
            return true;
        } catch (Exception ex) {
            log.error("saveAnswers failed for testId={}: {}", testId, ex.getMessage());
            return false;
        }
    }

    /** Returns all TestQuestions rows for a test (used by legacy TestController). */
    @Transactional(readOnly = true)
    public List<TestQuestions> getQuestionsByTestId(Integer testId) {
        return testQuestionsRepository.findByIdTestId(testId);
    }

    /**
     * Legacy entry point — creates a test by email + courseId only.
     * The new API requires a paperId; this stub is retained so the old
     * TestController compiles until it is rewritten.
     *
     * @deprecated use startTest(StartTestRequest, email) instead
     */
    @Deprecated
    public Integer createTestByEmail(String email, Integer courseId) {
        throw new UnsupportedOperationException(
                "Deprecated — use POST /api/tests/start with StartTestRequest (paperId required)");
    }
}