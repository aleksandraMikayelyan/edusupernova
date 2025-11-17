package data;

import model.User;

import java.sql.*;
import java.util.Optional;

public class UserDAO {
    private final Connection conexion;

    public UserDAO(Connection conexion) {
        this.conexion = conexion;
    }

    public void create(User usuario) {
        String sql = "INSERT INTO User (username, email, password) VALUES (?, ?)";
        try (PreparedStatement pstmt = conexion.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            pstmt.setString(1, usuario.getUsername());
            pstmt.setString(2, usuario.getEmail());
            pstmt.setString(3, usuario.getPassword());
            pstmt.executeUpdate();
            ResultSet rs = pstmt.getGeneratedKeys();
            if (rs.next()) {
                usuario.setId(rs.getInt(1));
            }
        } catch (SQLException e) {
            System.out.println("Error while registering new User: " + e.getMessage());
        }
    }


    public void update(User user) {
        String sql = "UPDATE User SET username = ?, email = ? , password = ? WHERE id = ?";
        try (PreparedStatement pstmt = conexion.prepareStatement(sql)) {
            pstmt.setString(1, user.getUsername());
            pstmt.setString(2, user.getEmail());
            pstmt.setInt(3, user.getId());
            pstmt.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error while updating the table User: " + e.getMessage());
        }
    }


    public void delete(int id) {
        String sql = "DELETE FROM User WHERE id = ?";
        try (PreparedStatement pstmt = conexion.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error while deleting a User: " + e.getMessage());
        }
    }


    public User findById(int id) {
        String sql = "SELECT * FROM User WHERE id = ?";
        try (PreparedStatement pstmt = conexion.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return new User(
                            rs.getInt("id"),
                            rs.getString("username"),
                            rs.getString("email"),
                            rs.getString("password")
                    );
                }
            }
        } catch (SQLException e) {
            System.out.println("Error al consultar Usuario: " + e.getMessage());
        }
        return null;
    }
}
