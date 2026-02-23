package com.edusupernova.edusupernova.data;


import com.edusupernova.edusupernova.model.Exams;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ExamRepository extends JpaRepository<Exams, Integer> {

    // 1. Standard listing for students
    List<Exams> findAllByIsActiveTrueOrderByExamnameAsc();

    // 2. The Clean Code way to search: Use both flags
    // Note: We pass the 'term' twice to the service call
    List<Exams> findByIsActiveTrueAndExamnameContainingIgnoreCaseOrIsActiveTrueAndDescriptionContainingIgnoreCaseOrderByExamnameAsc(
            String examname, String description);

    // 3. Counting utility
    long countByIsActiveTrue();
}