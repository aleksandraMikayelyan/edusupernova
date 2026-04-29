package com.edusupernova.edusupernova;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.CommandLineRunner;
import org.springframework.scheduling.annotation.EnableAsync;

import org.springframework.context.annotation.Bean;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import javax.sql.DataSource;
import java.sql.Connection;

@SpringBootApplication
@EnableAsync
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

    /*@Bean
    public WebMvcConfigurer corsConfigurer() {
        return new WebMvcConfigurer() {
            @Override
            public void addCorsMappings(CorsRegistry registry) {
                registry.addMapping("/**")
                        .allowedOrigins("http://localhost:8082") // Tu puerto de React
                        .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")
                        .allowedHeaders("*")
                        .allowCredentials(true);
            }
        };
    }*/

}
