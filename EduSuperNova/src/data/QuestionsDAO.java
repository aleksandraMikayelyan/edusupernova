package data;

import model.Questions;
import model.Subject;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class QuestionsDAO {
    Connection conn;
    public QuestionsDAO(Connection conn) {
        this.conn = conn;
    }

    public List<Questions> randomQuestionsTestGenerator(int subjectId) {
        List<Questions> questions = new ArrayList<>();

        String sqlMC = """
            SELECT id, asignatura_id, texto_pregunta, tipo, opciones, respuesta_correcta
            FROM Preguntas
            WHERE asignatura_id = ? AND tipo = 'multiple_choice'
            ORDER BY RAND()
            LIMIT 15
            """;

        String sqlOpen = """
            SELECT id, asignatura_id, texto_pregunta, tipo, opciones, respuesta_correcta
            FROM Preguntas
            WHERE asignatura_id = ? AND tipo IN ('open_ended', 'resolucion_problema')
            ORDER BY RAND()
            LIMIT 5
            """;

            // 15 multiple choice
            try (PreparedStatement ps = conn.prepareStatement(sqlMC)) {
                ps.setInt(1, subjectId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        questions.add(mapearPregunta(rs));
                    }
                }
            }catch (SQLException e) {
                System.err.println("Error generando test aleatorio para asignatura " + subjectId );
                e.printStackTrace();
            }
            // 5 abiertas / resolución
            try (PreparedStatement ps = conn.prepareStatement(sqlOpen)) {
                ps.setInt(1, subjectId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        questions.add(mapearPregunta(rs));
                    }
                }
            }catch (SQLException e) {
                System.err.println("Error generando test aleatorio para asignatura " + subjectId );
                e.printStackTrace();
            }
            return questions; // 20 preguntas en orden aleatorio
        }

    private Questions mapearPregunta(ResultSet rs) throws SQLException {
        Questions q = new Questions();

        q.setId(rs.getInt("id"));

        Subject subject = new Subject();
        subject.setId(rs.getInt("subject_id"));
        q.setSubject(subject);

        q.setQuestion(rs.getString("question_text"));

        String typeDb = rs.getString("type");
        Questions.type tipo = switch (typeDb) {
            case "multiple_choice", "multipleChoice" -> Questions.type.multipleChoice;
            case "open_ended", "openEnded" -> Questions.type.openEnded;
            case "logical_problems", "resolucion_problema", "logicalProblems" -> Questions.type.logicalProblems;
            default -> Questions.type.openEnded;
        };
        q.setQuestionType(tipo);

        q.setOptions(rs.getString("options"));
        q.setAnswer(rs.getString("correct_answer"));
        q.setPrompt_ia(rs.getString("prompt_ia"));

        return q;
    }

    public int contarPorTipo(int subject_id, String type) {
        String sql = "SELECT COUNT(*) FROM Quiz WHERE subject_id = ? AND type = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, subject_id);
            ps.setString(2, type);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        } catch (SQLException e) {
            return 0;
        }
    }

    }

