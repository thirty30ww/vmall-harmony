package org.example.vmall_home_demo.controller;

import org.example.vmall_home_demo.dto.AuthResponse;
import org.example.vmall_home_demo.dto.LoginRequest;
import org.example.vmall_home_demo.dto.RegisterRequest;
import org.example.vmall_home_demo.dto.SendCodeRequest;
import org.example.vmall_home_demo.dto.SendCodeResponse;
import org.example.vmall_home_demo.service.AuthService;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/auth")
public class AuthController {
    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    @PostMapping("/send-code")
    public SendCodeResponse sendCode(@RequestBody SendCodeRequest request) {
        return authService.sendCode(request);
    }

    @PostMapping("/send-register-code")
    public SendCodeResponse sendRegisterCode(@RequestBody SendCodeRequest request) {
        return authService.sendRegisterCode(request);
    }

    @PostMapping("/register")
    public AuthResponse register(@RequestBody RegisterRequest request) {
        return authService.register(request);
    }

    @PostMapping("/login")
    public AuthResponse login(@RequestBody LoginRequest request) {
        return authService.login(request);
    }
}