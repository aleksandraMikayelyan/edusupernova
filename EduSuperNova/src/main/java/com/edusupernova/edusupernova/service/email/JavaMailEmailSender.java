package com.edusupernova.edusupernova.service.email;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Component;

/**
 * SMTP implementation of {@link EmailSender} backed by Spring's JavaMailSender
 * (which internally uses Jakarta Mail).
 *
 * SRP: the sole responsibility of this class is constructing and dispatching
 * a transactional email message. It knows nothing about codes or users.
 *
 * OCP: to switch to SendGrid or AWS SES, create a new implementation of
 * {@link EmailSender} and swap the bean — this class stays untouched.
 */
@Component
@RequiredArgsConstructor
public class JavaMailEmailSender implements EmailSender {

    private final JavaMailSender mailSender;

    @Value("${spring.mail.username}")
    private String from;

    @Override
    public void sendVerificationCode(String to, String code) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setFrom(from);
        message.setTo(to);
        message.setSubject("EduSuperNova — Código de verificación");
        message.setText(
                "¡Bienvenido/a a EduSuperNova!\n\n" +
                "Tu código de verificación es:\n\n" +
                "        " + code + "\n\n" +
                "El código caduca en 10 minutos.\n" +
                "Si no has creado una cuenta, puedes ignorar este mensaje.\n\n" +
                "— El equipo de EduSuperNova"
        );
        mailSender.send(message);
    }
}
