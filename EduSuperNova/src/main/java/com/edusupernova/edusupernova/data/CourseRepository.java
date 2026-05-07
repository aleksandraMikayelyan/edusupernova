package com.edusupernova.edusupernova.data;

import com.edusupernova.edusupernova.model.ALevelSection;
import com.edusupernova.edusupernova.model.Courses;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface CourseRepository extends JpaRepository<Courses, Integer> {

    @EntityGraph(attributePaths = {"units"})
    Optional<Courses> findById(Integer id);

    List<Courses> findByExamId(Integer examId);

    List<Courses> findByExamIdAndSection(Integer examId, ALevelSection section);
}
