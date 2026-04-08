package com.edusupernova.edusupernova.data;

import com.edusupernova.edusupernova.model.Paper;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PaperRepository extends JpaRepository<Paper, Integer> {

    /** All papers for a course sorted by display order. */
    List<Paper> findByCourseIdOrderByOrderIndex(Integer courseId);
}
