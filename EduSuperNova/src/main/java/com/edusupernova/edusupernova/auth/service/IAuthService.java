package com.edusupernova.edusupernova.auth.service;

import com.edusupernova.edusupernova.auth.dto.request.GoogleAuthRequest;
import com.edusupernova.edusupernova.auth.dto.request.LoginRequest;
import com.edusupernova.edusupernova.auth.dto.response.AuthResponse;

public interface IAuthService {

    AuthResponse login(LoginRequest request);

    AuthResponse googleAuth(GoogleAuthRequest request);
}
