package com.edusupernova.edusupernova.auth.service;

import com.edusupernova.edusupernova.auth.dto.request.UpdatePasswordRequest;
import com.edusupernova.edusupernova.auth.dto.request.UpdateProfileRequest;
import com.edusupernova.edusupernova.auth.dto.response.AuthResponse;
import com.edusupernova.edusupernova.shared.dto.response.MessageResponse;

public interface IUserProfileService {
    AuthResponse    updateProfile(Integer userId, UpdateProfileRequest request);
    MessageResponse updatePassword(Integer userId, UpdatePasswordRequest request);
    MessageResponse deleteAccount(Integer userId);
}
