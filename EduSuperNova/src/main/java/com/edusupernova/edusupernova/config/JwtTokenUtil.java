package com.edusupernova.edusupernova.config;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;
import org.springframework.security.core.userdetails.UserDetails;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.function.Function;
public class JwtTokenUtil {

        private static final String SECRET_KEY = "your-very-secure-secret-key-32-chars-min";  // Cambia a env var
        private static final long EXPIRATION_TIME = 86400000;  // 24 horas

        public static String generateToken(UserDetails userDetails) {
            Map<String, Object> claims = new HashMap<>();
            return Jwts.builder()
                    .setClaims(claims)
                    .setSubject(userDetails.getUsername())
                    .setIssuedAt(new Date(System.currentTimeMillis()))
                    .setExpiration(new Date(System.currentTimeMillis() + EXPIRATION_TIME))
                    .signWith(Keys.hmacShaKeyFor(SECRET_KEY.getBytes()), SignatureAlgorithm.HS512)
                    .compact();
        }

        public static Boolean validateToken(String token, UserDetails userDetails) {
            final String username = extractUsername(token);
            return (username.equals(userDetails.getUsername()) && !isTokenExpired(token));
        }

        public static String extractUsername(String token) {
            return extractClaim(token, Claims::getSubject);
        }

        private static <T> T extractClaim(String token, Function<Claims, T> claimsResolver) {
            final Claims claims = extractAllClaims(token);
            return claimsResolver.apply(claims);
        }

        private static Claims extractAllClaims(String token) {
            return Jwts.parser()
                    .verifyWith(Keys.hmacShaKeyFor(SECRET_KEY.getBytes())) // "setSigningKey" is now "verifyWith"
                    .build()
                    .parseSignedClaims(token) // "parseClaimsJws" is now "parseSignedClaims"
                    .getPayload(); // "getBody" is now "getPayload"
        }

        private static Boolean isTokenExpired(String token) {
            return extractExpiration(token).before(new Date());
        }

        private static Date extractExpiration(String token) {
            return extractClaim(token, Claims::getExpiration);
        }
    }

