package com.edusupernova.edusupernova.data;

import com.edusupernova.edusupernova.model.Users;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<Users, Integer> {

    // BUSCAR USUARIO POR EMAIL (para login) → devuelve Optional
    Optional<Users> findByEmail(String email);

    // BUSCAR USUARIO POR USERNAME (opcional, si quieres login por username)
    Users findByUsername(String username);

    // Comprobar si existe por email (útil para validación de registro)
    boolean existsByEmail(String email);

    // Comprobar si existe por username
    boolean existsByUsername(String username);

    // Opcional: obtener solo el salt por email (aunque con findByEmail ya lo tienes todo)
    // @Query("SELECT u.salt FROM User u WHERE u.email = :email")
    // String getSaltByEmail(@Param("email") String email);
}