package com.edusupernova.edusupernova.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.Ordered;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.springframework.web.filter.CorsFilter;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Value("${app.file.upload-dir}")
    private String uploadDir;

    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**")                    // todas las rutas
                .allowedOrigins("*")  // tu frontend
                .allowedMethods("*")                  // GET, POST, PUT, DELETE, OPTIONS
                .allowedHeaders("*")
                .allowCredentials(false);             // false porque usas "*"
    }

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // Servir imágenes desde la carpeta externa
        registry.addResourceHandler("/images/**")
                .addResourceLocations("file:" + uploadDir);
    }

    @Bean
    public FilterRegistrationBean<CorsFilter> corsFilter() {
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        CorsConfiguration config = new CorsConfiguration();

        config.setAllowCredentials(false); // Cambiar a true si usas Cookies/Sessions
        config.addAllowedOrigin("*");      // En producción usa el dominio real
        config.addAllowedHeader("*");
        config.addAllowedMethod("*");      // GET, POST, PUT, DELETE, PATCH, OPTIONS

        source.registerCorsConfiguration("/**", config);
        FilterRegistrationBean<CorsFilter> bean = new FilterRegistrationBean<>(new CorsFilter(source));
        bean.setOrder(Ordered.HIGHEST_PRECEDENCE); // <--- ESTO ES LO MÁS IMPORTANTE
        return bean;
    }

}
