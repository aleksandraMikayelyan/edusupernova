package com.edusupernova.edusupernova.config;

import com.edusupernova.edusupernova.data.UserRepository;
import com.edusupernova.edusupernova.model.Users;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;

import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;


@Configuration
public class SecurityConfig {

    // Crearemos esto después
    private final UserRepository userRepository;

    public SecurityConfig(JwtAuthenticationFilter jwtFilter, UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    // 1. EL BEAN QUE TE FALTABA: Define cómo buscar al usuario
    @Bean
    public UserDetailsService userDetailsService() {
        return email -> {
            Users user = userRepository.findByEmail(email);
            if (user.isEnabled()) {
                throw new UsernameNotFoundException("Usuario no encontrado: " + email);
            }
            return user; // Aquí devuelve el objeto Users (que ya implementa UserDetails)
        };
    }

    @Bean
    public SecurityFilterChain securityFilterChain(JwtAuthenticationFilter jwtFilter,HttpSecurity http) throws Exception {
        http
                .csrf(csrf -> csrf.disable())  // Para API REST
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers("/api/auth/**").permitAll()  // Login/Register abiertos
                        .anyRequest().authenticated()  // Resto protegido
                )
                .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS));
        http.addFilterBefore(jwtFilter, UsernamePasswordAuthenticationFilter.class);
        return http.build();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration config) throws Exception {
        return config.getAuthenticationManager();
    }
}