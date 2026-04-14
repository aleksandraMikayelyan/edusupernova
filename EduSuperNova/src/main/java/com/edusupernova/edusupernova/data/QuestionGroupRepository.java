package com.edusupernova.edusupernova.data;

import com.edusupernova.edusupernova.model.QuestionGroup;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface QuestionGroupRepository extends JpaRepository<QuestionGroup, Integer> {

    /** Returns all groups for a paper ordered by their display position. */
    List<QuestionGroup> findByPaperIdOrderByOrderIndexAsc(Integer paperId);
}
