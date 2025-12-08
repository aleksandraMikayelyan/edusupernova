package security;
import java.security.SecureRandom;
import java.util.Base64;
import javax.crypto.spec.PBEKeySpec;
import javax.crypto.SecretKeyFactory;
public class PasswordUtils {

        private static final int ITERATIONS = 100000;
        private static final int KEY_LENGTH = 256;

        // Genera un salt aleatorio
        public static String generateSalt() {
            SecureRandom random = new SecureRandom();
            byte[] salt = new byte[16];
            random.nextBytes(salt);
            return Base64.getEncoder().encodeToString(salt);
        }

        // Hashea la contraseña con el salt
        public static String hashPassword(String password, String salt) {
            try {
                PBEKeySpec spec = new PBEKeySpec(
                        password.toCharArray(),
                        Base64.getDecoder().decode(salt),
                        ITERATIONS,
                        KEY_LENGTH
                );
                SecretKeyFactory skf = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");
                byte[] hash = skf.generateSecret(spec).getEncoded();
                return Base64.getEncoder().encodeToString(hash);
            } catch (Exception e) {
                throw new RuntimeException("Error hasheando contraseña", e);
            }
        }

        // Verifica si la contraseña es correcta
        public static boolean verifyPassword(String password, String storedHash, String salt) {
            String newHash = hashPassword(password, salt);
            return newHash.equals(storedHash);
        }
    }

