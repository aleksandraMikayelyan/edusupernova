package service;

import data.ConnectionDB;
import data.UserDAO;
import model.User;
import security.PasswordUtils;
public class UserService {
    ConnectionDB connectionDB = new ConnectionDB();
    private final UserDAO userDAO = new UserDAO(connectionDB.getConnection());

        // REGISTRO SEGURO (con hash + salt)
        public boolean register(String username, String email, String rawPassword) {
            // Comprobar si el email ya existe
            if (userDAO.findByEmail(email) != null) {
                return false; // ya registrado
            }

            // 1. Generamos salt aleatorio
            String salt = PasswordUtils.generateSalt();

            // 2. Hasheamos la contraseña con el salt
            String hashedPassword = PasswordUtils.hashPassword(rawPassword, salt);

            // 3. Creamos el usuario
            User user = new User();
            user.setUsername(username);
            user.setEmail(email);
            user.setPassword(hashedPassword); // guardamos el hash, NO la contraseña en plano

            // 4. Guardamos usuario + salt en la DB (el DAO lo hace)
            return userDAO.registerWithSalt(user, salt);
        }

        // LOGIN SEGURO
        public User login(String email, String rawPassword) {
            User user = userDAO.findByEmail(email);

            if (user == null) {
                return null;
            }

            // Obtenemos el salt guardado para este usuario
            String storedSalt = userDAO.getSaltByEmail(email);

            // Verificamos si la contraseña coincide
            if (PasswordUtils.verifyPassword(rawPassword, user.getPassword(), storedSalt)) {
                return user;
            }

            return null; // contraseña incorrecta
        }

        // Opcional: cambiar contraseña (con verificación de la antigua)
        public boolean changePassword(int userId, String oldPassword, String newPassword) {
            User user = userDAO.findById(userId);
            if (user == null) return false;

            String storedSalt = userDAO.getSaltByEmail(user.getEmail());

            if (!PasswordUtils.verifyPassword(oldPassword, user.getPassword(), storedSalt)) {
                return false; // antigua incorrecta
            }

            String newSalt = PasswordUtils.generateSalt();
            String newHash = PasswordUtils.hashPassword(newPassword, newSalt);

            user.setPassword(newHash);
            return userDAO.updatePasswordWithSalt(userId, newHash, newSalt);
        }
    }


