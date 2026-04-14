package com.edusupernova.edusupernova.service;

import com.edusupernova.edusupernova.data.QuestionGroupRepository;
import com.edusupernova.edusupernova.dto.response.QuestionGroupDTO;
import com.edusupernova.edusupernova.dto.response.QuizDTO;
import com.edusupernova.edusupernova.model.Quiz;
import com.edusupernova.edusupernova.model.QuestionGroup;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Comparator;
import java.util.List;

/**
 * Read-only service for QuestionGroup data.
 * Used by admin panels and any endpoint that needs to surface
 * structured Paper 2 / Paper 3 content.
 */
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class QuestionGroupService {

    private final QuestionGroupRepository groupRepository;

    /**
     * Returns all groups for a paper, each with its sub-questions ordered
     * by groupOrderIndex.
     */
    public List<QuestionGroupDTO> getGroupsForPaper(Integer paperId) {
        return groupRepository.findByPaperIdOrderByOrderIndexAsc(paperId)
                .stream()
                .map(this::toDTO)
                .toList();
    }

    // ── Mappers ───────────────────────────────────────────────────────────────

    private QuestionGroupDTO toDTO(QuestionGroup group) {
        List<QuizDTO> questions = group.getQuestions() == null
                ? List.of()
                : group.getQuestions().stream()
                        .sorted(Comparator.comparingInt(
                                q -> q.getGroupOrderIndex() != null ? q.getGroupOrderIndex() : 0))
                        .map(this::toQuizDTO)
                        .toList();

        return new QuestionGroupDTO(
                group.getId(),
                group.getTitle(),
                group.getContextText(),
                group.getContextImageUrl(),
                group.getOrderIndex(),
                questions
        );
    }

    private QuizDTO toQuizDTO(Quiz q) {
        return new QuizDTO(
                q.getId(),
                q.getQuestionText(),
                q.getOptionA(),
                q.getOptionB(),
                q.getOptionC(),
                q.getOptionD(),
                q.getOptionE(),
                q.getCorrectAnswer(),
                q.getQuestionType().name(),
                q.getDifficulty() != null ? q.getDifficulty().name() : "MEDIUM",
                q.getMarks(),
                q.getGroupOrderIndex()
        );
    }
}
