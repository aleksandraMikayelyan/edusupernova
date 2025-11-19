package data;

import model.User;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Optional;

public class UserDAO {
    Connection conn;

    public UserDAO(Connection conn) {
        this.conn = conn;
    }

    public boolean registerWithSalt(User user, String salt) {
        String sql = "INSERT INTO Users (username, email, password_hash, salt) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, user.getUsername());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword()); // password_hash
            ps.setString(4, salt);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error registrando usuario: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // BUSCAR USUARIO POR EMAIL (para login)
    public User findByEmail(String email) {
        String sql = "SELECT id, username, email, password_hash, salt FROM Users WHERE email = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setId(rs.getInt("id"));
                    user.setUsername(rs.getString("username"));
                    user.setEmail(rs.getString("email"));
                    user.setPassword(rs.getString("password_hash"));
                    // salt se obtiene con getSaltByEmail si es necesario
                    return user;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // OBTENER SALT POR EMAIL (nuevo método necesario para login)
    public String getSaltByEmail(String email) {
        String sql = "SELECT salt FROM Users WHERE email = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("salt");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // BUSCAR USUARIO POR ID (opcional pero útil)
    public User findById(int id) {
        String sql = "SELECT id, username, email, password_hash FROM Users WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setId(rs.getInt("id"));
                    user.setUsername(rs.getString("username"));
                    user.setEmail(rs.getString("email"));
                    user.setPassword(rs.getString("password_hash"));
                    return user;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // ACTUALIZAR CONTRASEÑA + SALT (para cambio de contraseña)
    public boolean updatePasswordWithSalt(int userId, String newHash, String newSalt) {
        String sql = "UPDATE Users SET password_hash = ?, salt = ? WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newHash);
            ps.setString(2, newSalt);
            ps.setInt(3, userId);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}


