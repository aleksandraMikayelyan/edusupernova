package com.edusupernova.edusupernova.data;

import com.edusupernova.edusupernova.model.Quiz;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface QuizRepository extends JpaRepository<Quiz, Integer> {

    // Fetch all questions of a specific type for a course
    List<Quiz> findByCourseIdAndType(Integer courseId, String type);

    // Fetch questions where the type is in a specific list (Open Ended OR Logical)
    List<Quiz> findByCourseIdAndTypeIn(Integer courseId, List<String> types);

    long countByCourseIdAndType(Integer courseId, String type);

    long countByCourseId(Integer courseId);
}