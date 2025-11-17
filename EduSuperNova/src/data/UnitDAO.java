package data;

import model.Subject;
import model.Unit;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class UnitDAO {
    Connection conn;
    public UnitDAO(Connection conn) {
        this.conn = conn;
    }
    public List<Unit> getBySubjectId(int subjectId) {
        List<Unit> units = new ArrayList<>();
        String sql = """
            SELECT
                u.id, u.title, u.queue, u.summary,
                s.id AS s_id, s.subject_name, s.description, s.subject_type
            FROM Units u
            JOIN Subjects s ON u.subject_id = s.id
            WHERE u.subject_id = ?
            ORDER BY u.queue ASC
            """;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, subjectId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    units.add(mapUnit(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al cargar unidades de subject_id: " + subjectId);
            e.printStackTrace();
        }
        return units;
    }

    // 2. Obtener una unidad concreta por ID (con su Subject completo)
    public Unit getById(int unitId) {
        String sql = """
            SELECT
                u.id, u.title, u.queue, u.summary,
                s.id AS s_id, s.subject_name, s.description, s.subject_type
            FROM Units u
            JOIN Subjects s ON u.subject_id = s.id
            WHERE u.id = ?
            """;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, unitId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapUnit(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al cargar Unit ID: " + unitId);
            e.printStackTrace();
        }
        return null;
    }

    // MÉTODO PRIVADO: convierte ResultSet → Unit con Subject completo
    private Unit mapUnit(ResultSet rs) throws SQLException {
        // Primero creamos el Subject
        Subject subject = new Subject();
        subject.setId(rs.getInt("s_id"));
        subject.setSubjectName(rs.getString("subject_name"));
        subject.setDescription(rs.getString("description"));
        subject.setSubjectType(rs.getString("subject_type"));

        // Luego la Unit
        Unit unit = new Unit();
        unit.setId(rs.getInt("id"));
        unit.setTitle(rs.getString("title"));
        unit.setQueue(rs.getInt("queue"));
        unit.setSummary(rs.getString("summary"));
        unit.setSubject(subject);

        return unit;
    }
}
