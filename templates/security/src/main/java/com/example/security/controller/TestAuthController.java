package com.example.security.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/auth")
public class TestAuthController {
    @GetMapping("/hello-user")
    public String hello() {
        return "Hello World!";
    }

    @GetMapping("/hello-admin")
    public String helloSecured() {
        return "Hello World! Admin";
    }
}
