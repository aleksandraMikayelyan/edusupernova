package com.edusupernova.edusupernova.test.service;

import com.edusupernova.edusupernova.data.*;
import com.edusupernova.edusupernova.test.dto.request.StartTestRequest;
import com.edusupernova.edusupernova.test.dto.response.TestSessionDTO;
import com.edusupernova.edusupernova.exception.ForbiddenException;
import com.edusupernova.edusupernova.exception.ResourceNotFoundException;
import com.edusupernova.edusupernova.model.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * Manages test session lifecycle: creating new sessions and resuming existing ones.
 */
@Slf4j
@Service
@RequiredArgsConstructor
@Transactional
public class TestSessionService implements ITestSessionService {

    private final TestRepository           testRepository;
    private final TestQuestionsRepository  testQuestionsRepository;
    private final UserRepository           userRepository;
    private final CourseRepository         courseRepository;
    private final PaperRepository          paperRepository;
    private final UnitRepository           unitRepository;
    private final QuizRepository           quizRepository;
    private final QuizService              quizService;
    private final TestMapper               testMapper;
    private final TestScoringHelper        scoringHelper;

    // ── Start ─────────────────────────────────────────────────────────────────

    @Override
    public TestSessionDTO startTest(StartTestRequest request, String email) {
        Users   user   = findUserByEmail(email);
        Courses course = findCourse(request.courseId());
        Paper   paper  = request.paperId() != null
                ? findPaper(request.paperId())
                : findFirstPaperForCourse(request.courseId());
        Unit    unit   = request.unitId() != null ? findUnit(request.unitId()) : null;

        int timeLimitMinutes = paper.getTimeLimitMinutes() != null
                ? paper.getTimeLimitMinutes()
                : course.getExam().getTimeLimitMinutes();

        List<Quiz> questions;

        if (request.forceGroupId() != null) {
            questions = quizRepository.findByQuestionGroupId(request.forceGroupId());
            questions.sort(java.util.Comparator.comparingInt(
                    q -> q.getGroupOrderIndex() != null ? q.getGroupOrderIndex() : 0));
            log.info("startTest forceGroupId={} → {} questions", request.forceGroupId(), questions.size());
        } else {
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

        if (request.forceGroupId() == null) {
            Set<Integer> newQuizIds = questions.stream().map(Quiz::getId).collect(Collectors.toSet());
            Optional<Tests> existing = findMatchingInProgressTest(user.getId(), paper.getId(), newQuizIds);
            if (existing.isPresent()) {
                Tests resumed = existing.get();
                boolean hasTimeLimit = resumed.getTimeLimitMinutes() != null;
                boolean hasTimeLeft  = scoringHelper.getRemainingSeconds(resumed) > 0;
                if (!hasTimeLimit || hasTimeLeft) {
                    List<TestQuestions> tqs = testQuestionsRepository.findByIdTestId(resumed.getId());
                    log.info("Resuming IN_PROGRESS testId={} (same question set)", resumed.getId());
                    return testMapper.toSessionDTO(resumed, tqs, paper, unit, timeLimitMinutes);
                }
                // Time expired — abandon the stale session and fall through to create a fresh one
                resumed.setStatus(Tests.TestStatus.ABANDONED);
                testRepository.save(resumed);
                log.info("Abandoned expired testId={}, starting fresh", resumed.getId());
            }
        }

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

        List<TestQuestions> testQuestions = questions.stream()
                .map(quiz -> scoringHelper.buildTestQuestion(saved, quiz))
                .toList();
        testQuestionsRepository.saveAll(testQuestions);

        log.info("Started testId={} userId={} paperId={} unitId={} questions={}",
                saved.getId(), user.getId(), paper.getId(),
                unit != null ? unit.getId() : "all", testQuestions.size());

        return testMapper.toSessionDTO(saved, testQuestions, paper, unit, timeLimitMinutes);
    }

    // ── Resume ────────────────────────────────────────────────────────────────

    @Override
    @Transactional(readOnly = true)
    public TestSessionDTO getSession(Integer testId, String email) {
        Tests test = findTest(testId);
        assertOwnership(test, email);
        List<TestQuestions> allQuestions = testQuestionsRepository.findByIdTestId(testId);
        return testMapper.toSessionDTO(test, allQuestions, test.getPaper(), test.getUnit(), test.getTimeLimitMinutes());
    }

    @Override
    public long getRemainingSeconds(Tests test) {
        return scoringHelper.getRemainingSeconds(test);
    }

    @Override
    @Transactional(readOnly = true)
    public List<TestQuestions> getQuestionsByTestId(Integer testId) {
        return testQuestionsRepository.findByIdTestId(testId);
    }

    // ── Private helpers ───────────────────────────────────────────────────────

    private Optional<Tests> findMatchingInProgressTest(Integer userId, Integer paperId, Set<Integer> targetQuizIds) {
        List<Tests> inProgress = testRepository.findByUserIdAndPaperIdAndStatus(
                userId, paperId, Tests.TestStatus.IN_PROGRESS);
        return inProgress.stream()
                .filter(t -> {
                    Set<Integer> existing = testQuestionsRepository.findByIdTestId(t.getId())
                            .stream().map(tq -> tq.getId().getQuizId()).collect(Collectors.toSet());
                    return existing.equals(targetQuizIds);
                })
                .findFirst();
    }

    private Users findUserByEmail(String email) {
        Users user = userRepository.findByEmail(email);
        if (user == null) throw new IllegalArgumentException("User not found: " + email);
        return user;
    }

    private Tests findTest(Integer testId) {
        return testRepository.findById(testId)
                .orElseThrow(() -> new ResourceNotFoundException("Test not found: " + testId));
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
        if (papers.isEmpty()) throw new IllegalStateException("No papers found for courseId=" + courseId);
        return papers.get(0);
    }

    private Unit findUnit(Integer unitId) {
        return unitRepository.findById(unitId)
                .orElseThrow(() -> new IllegalArgumentException("Unit not found: " + unitId));
    }

    private void assertOwnership(Tests test, String email) {
        if (!test.getUser().getEmail().equals(email)) {
            throw new ForbiddenException("Test does not belong to user: " + email);
        }
    }
}
