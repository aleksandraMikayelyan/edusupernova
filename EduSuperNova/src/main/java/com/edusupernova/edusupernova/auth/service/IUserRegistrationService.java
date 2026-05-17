package com.edusupernova.edusupernova.auth.service;

import com.edusupernova.edusupernova.auth.dto.request.RegisterRequest;
import com.edusupernova.edusupernova.auth.dto.request.VerifyEmailRequest;
import com.edusupernova.edusupernova.auth.dto.response.AuthResponse;
import com.edusupernova.edusupernova.shared.dto.response.MessageResponse;

public interface IUserRegistrationService {

    MessageResponse register(RegisterRequest request);

    AuthResponse verifyEmail(VerifyEmailRequest request);
}
