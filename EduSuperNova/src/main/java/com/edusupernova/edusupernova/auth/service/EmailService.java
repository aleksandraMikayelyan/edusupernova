package com.edusupernova.edusupernova.auth.service;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import java.io.UnsupportedEncodingException;

@Service
@RequiredArgsConstructor
public class EmailService {

    private final JavaMailSender mailSender;

    @Value("${app.email.from}")
    private String fromAddress;

    @Async("emailExecutor")
    public void sendVerificationCode(String toEmail, String code) {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setFrom(fromAddress, "EduSupernova");
            helper.setReplyTo("noreply@edu-supernova.com");
            helper.setTo(toEmail);
            helper.setSubject("Your EduSupernova verification code");
            helper.setText(
                "<div style='font-family:Georgia,serif;max-width:480px;margin:0 auto;padding:32px'>" +
                "<h2 style='color:#0a5f6e;margin:0 0 16px'>Verify your email</h2>" +
                "<p style='color:#334155;font-size:15px'>Enter this 6-digit code to complete your EduSupernova registration:</p>" +
                "<div style='font-size:40px;font-weight:700;letter-spacing:14px;" +
                     "color:#062f37;background:#F7F4EF;padding:24px;text-align:center;" +
                     "border-radius:12px;margin:24px 0'>" + code + "</div>" +
                "<p style='color:#94A3B8;font-size:13px'>This code expires in 10 minutes.<br>" +
                "If you did not create an account, you can safely ignore this email.</p>" +
                "</div>",
                true
            );

            mailSender.send(message);
        } catch (MessagingException | UnsupportedEncodingException e) {
            throw new RuntimeException("Failed to send verification email to " + toEmail, e);
        }
    }
}
