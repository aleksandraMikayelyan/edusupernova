package com.edusupernova.edusupernova.dto;

import com.edusupernova.edusupernova.model.Role;

public record RegisterRequest(String username,
                              String email,
                              String password,
                              Role rol) {
}
/*"accessToken": "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJhcmRlbjJzYW50aXhtZXJAZ21haWwuY29tIiwiaWF0IjoxNzcxODU0MTM0LCJleHAiOjE3NzE5NDA1MzR9.IwBsWqlRFgA9HvWBS_E1Vq5lgr6vHSVD1KDCqaRbP2o"*/