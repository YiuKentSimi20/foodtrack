package com.licenta.foodtrack.controller;


import com.licenta.foodtrack.auth.AuthenticationRequest;
import com.licenta.foodtrack.auth.AuthenticationResponse;
import com.licenta.foodtrack.auth.RegisterRequest;
import com.licenta.foodtrack.service.AuthenticationService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/foodtrack/user/auth")
@RequiredArgsConstructor
public class AuthenticationController {
    public final AuthenticationService authenticationService;

    @PostMapping("/register")
    public ResponseEntity<AuthenticationResponse> register(@Valid @RequestBody RegisterRequest registerRequest) {
        return ResponseEntity.ok(authenticationService.register(registerRequest));
    }

    @PostMapping("/login")
    public ResponseEntity<AuthenticationResponse> login(@Valid @RequestBody AuthenticationRequest authenticationRequest) {
        return ResponseEntity.ok(authenticationService.login(authenticationRequest));
    }

    @PostMapping("/register/test")
    public ResponseEntity<RegisterRequest> registerTest(@Valid @RequestBody RegisterRequest registerRequest) {
        return ResponseEntity.ok(registerRequest);
    }




}
