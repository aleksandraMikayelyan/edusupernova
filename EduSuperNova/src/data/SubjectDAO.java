package data;

import model.Subject;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;



public class SubjectDAO {
    Connection conn;
    public SubjectDAO(Connection conn) {
        this.conn = conn;
    }

    public List<Subject> dashboard() {
        List<Subject> subjects = new ArrayList<>();
        String sql = "SELECT id, title, description, type FROM Subject ORDER BY title";

        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Subject a = new Subject(
                        rs.getInt("id"),
                        rs.getString("title"),
                        rs.getString("description"),
                        rs.getString("type")
                );
                subjects.add(a);
            }
        } catch (SQLException e) {
            System.err.println("Error while obtaining the new subject: " + e.getMessage());
            e.printStackTrace();
        }
        return subjects;
    }
    public List<Subject> search(String search) {
        List<Subject> subjects = new ArrayList<>();
        if (search == null || search.trim().isEmpty()) {
            return subjects; // lista vacía
        }

        String query = """
        SELECT id, title, description, type
        FROM Subject
        WHERE LOWER(title) LIKE ? OR LOWER(description) LIKE ?
        ORDER BY
            CASE
            WHEN LOWER(title) LIKE ? THEN 1   -- coincidencia exacta al inicio del nombre
                WHEN LOWER(title) LIKE ? THEN 2   -- coincidencia parcial en nombre
                ELSE 3
            END,
            title
        LIMIT 20
        """;

        String likeTerm = "%" + search.trim().toLowerCase() + "%";
        String startsWithTerm = search.trim().toLowerCase() + "%";

        try (PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setString(1, likeTerm);           // nombre contiene
            ps.setString(2, likeTerm);           // descripción contiene
            ps.setString(3, startsWithTerm);     // nombre empieza por...
            ps.setString(4, likeTerm);           // resto de coincidencias

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Subject a = new Subject(
                            rs.getInt("id"),
                            rs.getString("title"),
                            rs.getString("description"),
                            rs.getString("type")
                    );
                    subjects.add(a);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error en búsqueda de asignaturas: " + e.getMessage());
            e.printStackTrace();
        }

        return subjects;
    }

    public Subject findById(int asignaturaId) {
        //Subject s = null;
        String sql = "SELECT id, title, description, type FROM Subject WHERE id = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, asignaturaId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Subject(
                             rs.getInt("id"),
                             rs.getString("title"),
                             rs.getString("description"),
                             rs.getString("type")
                    );
                }
            }
        } catch (SQLException e) {
            System.err.println("Error while obtaining the subject by id: " + asignaturaId + ": " + e.getMessage());
        }
        return null;
    }

    public boolean insertSubject(Subject sub) {
        String sql = "INSERT INTO Subject (title, description, type) VALUES (?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, sub.getSubjectName());
            ps.setString(2, sub.getDescription());
            ps.setString(3, sub.getSubjectType());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
        System.err.println("Error while inserting new subject:  "+e.getMessage());
            return false;
        }
    }
}
