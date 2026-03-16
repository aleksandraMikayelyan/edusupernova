package com.edusupernova.edusupernova.dto;

import lombok.Data;

@Data
public class StartTestRequest {
    private String email;
    private Integer courseId;
}
