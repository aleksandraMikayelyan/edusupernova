package com.edusupernova.edusupernova;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.CommandLineRunner;

import org.springframework.context.annotation.Bean;
import javax.sql.DataSource;
import java.sql.Connection;

@SpringBootApplication
public class EdusupernovaApplication {

	public static void main(String[] args) {
        SpringApplication.run(EdusupernovaApplication.class, args);
    }
    @Bean
    public CommandLineRunner testConnection(DataSource dataSource) {
        return args -> {
            try (Connection connection = dataSource.getConnection()) {
                System.out.println("¡Conexión exitosa a la DB! Metadata: " + connection.getMetaData().getURL());
            } catch (Exception e) {
                System.err.println("Error al conectar: " + e.getMessage());
            }
        };
    }

}
