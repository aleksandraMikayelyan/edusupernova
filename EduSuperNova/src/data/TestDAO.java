package data;

import model.TestQuestions;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.List;

public class TestDAO {
    Connection conn;
    public TestDAO(Connection conn) {
        this.conn = conn;
    }
    // 1. Crear test vacío y devolver su ID
        public int crearTest(int usuarioId, int asignaturaId) {
            String sql = "INSERT INTO Tests (usuario_id, asignatura_id, fecha) VALUES (?, ?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

                ps.setInt(1, usuarioId);
                ps.setInt(2, asignaturaId);
                ps.setTimestamp(3, Timestamp.valueOf(LocalDateTime.now()));
                ps.executeUpdate();

                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) return rs.getInt(1);
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
            return -1;
        }

        // 2. Guardar todas las respuestas del usuario de una vez
        public boolean saveAnswers(int testId, List<TestQuestions> answers) {
            String sql = """
            INSERT INTO Test_Question (test_id, question_id, user_response, correct_response, punctuation, feedback_ia)
            VALUES (?, ?, ?, ?, ?, ?)
            ON DUPLICATE KEY UPDATE
                user_response = VALUES(user_response),
                correct_response = VALUES(correct_response),
                punctuation = VALUES(punctuation),
                feedback_ia = VALUES(feedback_ia)
            """;

            try (PreparedStatement ps = conn.prepareStatement(sql)) {

                conn.setAutoCommit(false);

                for (TestQuestions tp : answers) {
                    ps.setInt(1, testId);
                    ps.setInt(2, tp.getQuestions().getId());
                    ps.setString(3, tp.getUser_answer());
                    ps.setBoolean(4, tp.isCorrect());
                    ps.setInt(5, tp.getPunctuation_ia());
                    ps.setString(6, tp.getFeedback_ai());
                    ps.addBatch();
                }

                ps.executeBatch();
                conn.commit();
                return true;
            } catch (SQLException e) {
                e.printStackTrace();
                return false;
            }
        }

        // 3. Actualizar puntuación final del test
        public void updatePunctuation(int testId, int punctuation) {
            String sql = "UPDATE Tests SET punctuation = ? WHERE id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, punctuation);
                ps.setInt(2, testId);
                ps.executeUpdate();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

