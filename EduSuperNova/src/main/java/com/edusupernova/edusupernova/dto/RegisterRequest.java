package com.edusupernova.edusupernova.dto;

import com.edusupernova.edusupernova.model.Role;

public record RegisterRequest(String username,
                              String email,
                              String password,
                              Role rol) {
}
