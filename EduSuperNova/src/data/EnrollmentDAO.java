package data;

import model.Subject;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EnrollmentDAO {
    Connection conn;
    public EnrollmentDAO(Connection conn) {
        this.conn = conn;
    }
        // Inscribir usuario en una asignatura
        public boolean enroll(int userId, int subjectId) {
            String sql = "INSERT IGNORE INTO Enrollment (user_id, subject_id) VALUES (?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, userId);
                ps.setInt(2, subjectId);
                return ps.executeUpdate() > 0;
            } catch (SQLException e) {
                e.printStackTrace();
                return false;
            }
        }

        // Desinscribir (opcional)
        public boolean unenroll(int userId, int subjectId) {
            String sql = "DELETE FROM Enrollment WHERE user_id = ? AND subject_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, userId);
                ps.setInt(2, subjectId);
                return ps.executeUpdate() > 0;
            } catch (SQLException e) {
                e.printStackTrace();
                return false;
            }
        }

        // Obtener todas las asignaturas inscritas por un usuario (con datos del subject)
        public List<Subject> getEnrolledSubjects(int userId) {
            List<Subject> subjects = new ArrayList<>();
            String sql = """
                    SELECT s.id, s.subject_name, s.description, s.subject_type
                    FROM Subjects s
                    JOIN Enrollment us ON s.id = us.subject_id
                    WHERE us.user_id = ?
            """;

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Subject s = new Subject();
                        s.setId(rs.getInt("id"));
                        s.setSubjectName(rs.getString("subject_name"));
                        s.setDescription(rs.getString("description"));
                        s.setSubjectType(rs.getString("subject_type"));
                        subjects.add(s);
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
            return subjects;
        }

        // Comprobar si ya está inscrito
        public boolean isEnrolled(int userId, int subjectId) {
            String sql = "SELECT 1 FROM Enrollment WHERE user_id = ? AND subject_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, userId);
                ps.setInt(2, subjectId);
                try (ResultSet rs = ps.executeQuery()) {
                    return rs.next();
                }
            } catch (SQLException e) {
                e.printStackTrace();
                return false;
            }
        }
}
