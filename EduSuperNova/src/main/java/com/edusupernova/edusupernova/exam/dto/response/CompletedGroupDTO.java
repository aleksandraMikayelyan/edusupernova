package com.edusupernova.edusupernova.exam.dto.response;

/**
 * One completed QuestionGroup (extract / passage / essay theme) shown on
 * the student's profile page.
 *
 * The frontend uses forceGroupId + paperId to wire up the "Practice again"
 * button → POST /api/tests/start with { courseId, paperId, forceGroupId }.
 */
public record CompletedGroupDTO(
        Integer groupId,
        String  groupTitle,
        String  contextText,       // first 300 chars shown as preview in profile
        Integer paperId,
        String  paperName,
        Integer courseId,
        String  courseName
) {}
