package com.edusupernova.edusupernova.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.Data;

import java.util.List;

/**
 * Groups several Quiz questions under a shared context (passage, table, topic).
 *
 * Examples:
 *   - A Level Paper 2 Data Response: one extract + 5 sub-questions (a-e)
 *   - A Level Paper 3 Essay:         one theme + parts (a) and (b)
 *   - IELTS/TOEFL Reading:           one passage + 10-13 questions
 *
 * Standalone questions (Paper 1 MCQ) do NOT have a QuestionGroup —
 * their Quiz.questionGroup is null and the test flow treats them normally.
 */
@Entity
@Table(name = "question_groups")
@Data
public class QuestionGroup {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    /** The paper this group belongs to (e.g. Paper 2 - Data Response). */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "idPaper", nullable = false)
    @JsonIgnore
    private Paper paper;

    /** Human-readable title shown above the extract. */
    @Column(length = 200)
    private String title;

    /** The passage, transcript, or introductory text that all sub-questions share. */
    @Column(columnDefinition = "TEXT")
    private String contextText;

    /** Optional URL to a chart or table image. */
    @Column(length = 500)
    private String contextImageUrl;

    /** Display order within the paper (group 1, group 2, …). */
    @Column(nullable = false)
    private Integer orderIndex;

    /** Sub-questions that reference this group's context. */
    @OneToMany(mappedBy = "questionGroup")
    @JsonIgnore
    private List<Quiz> questions;
}
