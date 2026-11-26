package com.edusupernova.edusupernova.auth.service;

import com.edusupernova.edusupernova.auth.dto.request.UpdatePasswordRequest;
import com.edusupernova.edusupernova.auth.dto.request.UpdateProfileRequest;
import com.edusupernova.edusupernova.auth.dto.response.AuthResponse;
import com.edusupernova.edusupernova.data.UserRepository;
import com.edusupernova.edusupernova.exception.BusinessRuleException;
import com.edusupernova.edusupernova.model.AuthProvider;
import com.edusupernova.edusupernova.model.Users;
import com.edusupernova.edusupernova.shared.dto.response.MessageResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Transactional
public class UserProfileService implements IUserProfileService {

    private final UserRepository      userRepository;
    private final PasswordEncoder     passwordEncoder;
    private final AuthResponseFactory authResponseFactory;

    @Override
    public AuthResponse updateProfile(Integer userId, UpdateProfileRequest request) {
        Users user = findUser(userId);

        if (!user.getEmail().equalsIgnoreCase(request.email())
                && userRepository.existsByEmail(request.email())) {
            throw new BusinessRuleException("Email already in use");
        }
        if (!user.getUsername().equalsIgnoreCase(request.username())
                && userRepository.existsByUsername(request.username())) {
            throw new BusinessRuleException("Username already in use");
        }

        user.setUsername(request.username());
        user.setEmail(request.email());
        userRepository.save(user);

        return authResponseFactory.build(user);
    }

    @Override
    public MessageResponse updatePassword(Integer userId, UpdatePasswordRequest request) {
        Users user = findUser(userId);
        if (user.getAuthProvider() == AuthProvider.GOOGLE) {
            throw new BusinessRuleException("This account uses Google Sign-In and has no password to change");
        }
        if (!passwordEncoder.matches(request.currentPassword(), user.getPassword())) {
            throw new BusinessRuleException("Current password is incorrect");
        }
        user.setPassword(passwordEncoder.encode(request.newPassword()));
        userRepository.save(user);
        return new MessageResponse("Password updated successfully");
    }

    @Override
    public MessageResponse deleteAccount(Integer userId) {
        Users user = findUser(userId);
        userRepository.delete(user);
        return new MessageResponse("Account deleted successfully");
    }

    private Users findUser(Integer userId) {
        return userRepository.findById(userId)
                .orElseThrow(() -> new BusinessRuleException("User not found"));
    }
}
