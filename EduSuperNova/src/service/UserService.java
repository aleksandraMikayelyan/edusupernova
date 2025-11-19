package service;

import data.ConnectionDB;
import data.UserDAO;
import model.User;

public class UserService {
    ConnectionDB connectionDB = new ConnectionDB();
    private final UserDAO userDAO = new UserDAO(connectionDB.getConnection());

    // Registro de usuario
    public boolean register(String username, String email, String password) {
        // Comprobamos si el email ya existe
        if (userDAO.findByEmail(email) != null) {
            return false; // ya existe
        }

        User user = new User();
        user.setUsername(username);
        user.setEmail(email);
        user.setPassword(password); // ← aquí irá el hash cuando lo añadamos

        return userDAO.insert(user);
    }

    // Login
    public User login(String email, String password) {
        User user = userDAO.findByEmail(email);
        if (user != null && user.getPassword().equals(password)) { // ← aquí irá la verificación con hash
            return user;
        }
        return null; // login fallido
    }

    // Buscar usuario por ID (útil para perfil, dashboard, etc.)
    public User getById(int userId) {
        return userDAO.findById(userId);
    }

    // Actualizar datos del usuario (ej: cambiar username o email)
    public boolean update(User user) {
        return userDAO.update(user);
    }

    // (Opcional) Cambiar contraseña - lo dejamos preparado para cuando añadamos hash
    public boolean changePassword(int userId, String oldPassword, String newPassword) {
        User user = getById(userId);
        if (user != null && user.getPassword().equals(oldPassword)) {
            user.setPassword(newPassword); // ← aquí irá el nuevo hash
            return userDAO.update(user);
        }
        return false;
    }
}

