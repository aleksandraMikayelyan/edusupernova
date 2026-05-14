package com.edusupernova.edusupernova.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class KeepAliveController {

    @GetMapping("/keep-alive")
    public String keepAlive() {
        return "Servidor activo";
    }
}