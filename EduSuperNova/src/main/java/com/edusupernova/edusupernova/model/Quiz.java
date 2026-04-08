@Entity
@Table(name = "Quizes")
@Data
public class Quiz {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "idQuiz")
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "idCourse", nullable = false)
    @com.fasterxml.jackson.annotation.JsonIgnore
    private Courses course;

    // ← Which paper format this question belongs to
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "idPaper", nullable = false)
    @com.fasterxml.jackson.annotation.JsonIgnore
    private Paper paper;

    // ← Which unit/topic this question tests
    // (allows filtering "Paper 1 questions from Unit 1 only")
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "idUnit", nullable = true)
    @com.fasterxml.jackson.annotation.JsonIgnore
    private Unit unit;

    @Column(columnDefinition = "TEXT", nullable = false)
    private String questionText;

    // MCQ options — null if not MCQ
    @Column(columnDefinition = "TEXT")
    private String optionA;
    @Column(columnDefinition = "TEXT")
    private String optionB;
    @Column(columnDefinition = "TEXT")
    private String optionC;
    @Column(columnDefinition = "TEXT")
    private String optionD;

    // For IELTS True/False/Not Given
    @Column(length = 20)
    private String optionE;

    // The correct answer
    // MCQ → "A" / "B" / "C" / "D"
    // OPEN_ENDED → model answer (IA compares)
    // NUMERIC_INPUT → "42"
    // TRUE_FALSE_NG → "TRUE" / "FALSE" / "NOT_GIVEN"
    @Column(columnDefinition = "TEXT", nullable = false)
    private String correctAnswer;

    // Shown after answer — base explanation before IA enriches it
    @Column(columnDefinition = "TEXT")
    private String explanation;

    // Custom prompt sent to Groq for this question type
    @Column(columnDefinition = "TEXT")
    private String promptIa;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Paper.PaperFormat type;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Difficulty difficulty = Difficulty.MEDIUM;

    public enum Difficulty { EASY, MEDIUM, HARD }

    @OneToMany(mappedBy = "quiz", cascade = CascadeType.ALL)
    @com.fasterxml.jackson.annotation.JsonIgnore
    private List<TestQuestions> testQuestions;
}