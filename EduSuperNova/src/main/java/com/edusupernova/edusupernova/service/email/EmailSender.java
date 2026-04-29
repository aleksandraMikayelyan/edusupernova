package com.edusupernova.edusupernova.service.email;

/**
 * Port for sending transactional emails.
 *
 * Defined as an interface following ISP and DIP: the verification business logic
 * depends on this abstraction, not on a concrete transport (SMTP, SendGrid, SES…).
 * Swapping implementations requires zero changes in calling code.
 */
public interface EmailSender {

    /**
     * Sends a one-time verification code to the given address.
     *
     * @param to   recipient email address
     * @param code the 6-digit code to embed in the message body
     */
    void sendVerificationCode(String to, String code);
}
