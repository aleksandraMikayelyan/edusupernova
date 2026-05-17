package com.edusupernova.edusupernova.exam.service;

import com.edusupernova.edusupernova.data.CourseRepository;
import com.edusupernova.edusupernova.model.ALevelSection;
import com.edusupernova.edusupernova.model.Courses;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.edusupernova.edusupernova.exception.ResourceNotFoundException;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class CourseService {

    private final CourseRepository courseRepository;
    private final UnitService      unitService;

    public Courses getCourseWithUnits(Integer courseId) {
        return courseRepository.findById(courseId)
                .orElseThrow(() -> ResourceNotFoundException.of("Course", courseId));
    }

    public List<UnitService.UnitWithContent> getUnitsForCourse(Integer courseId) {
        assertCourseExists(courseId);
        return unitService.getUnitsByCourseId(courseId);
    }

    public Courses getCourseBasicInfo(Integer courseId) {
        return courseRepository.findById(courseId)
                .orElseThrow(() -> ResourceNotFoundException.of("Course", courseId));
    }

    public List<Courses> getCoursesByExamId(Integer examId) {
        return courseRepository.findByExamId(examId);
    }

    public List<Courses> getCoursesByExamIdAndSection(Integer examId, ALevelSection section) {
        return courseRepository.findByExamIdAndSection(examId, section);
    }

    private void assertCourseExists(Integer courseId) {
        if (!courseRepository.existsById(courseId)) {
            throw ResourceNotFoundException.of("Course", courseId);
        }
    }
}
