package com.licenta.foodtrack.controller;


import com.licenta.foodtrack.auth.AuthenticationResponse;
import com.licenta.foodtrack.auth.RegisterRequest;
import com.licenta.foodtrack.model.Utilizator;
import com.licenta.foodtrack.service.UtilizatorService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/foodtrack/user")
@RequiredArgsConstructor
public class UtilizatorController {
    public final UtilizatorService utilizatorService;

    @PostMapping("/auth/register")
    public ResponseEntity<AuthenticationResponse> register(@Valid @RequestBody RegisterRequest registerRequest) {


       Utilizator utilizator = utilizatorService.register(registerRequest);


       return ResponseEntity.ok(AuthenticationResponse.builder()
               .token(utilizator.getEmail())
               .build());

    }

    @PostMapping("/auth/register/test")
    public ResponseEntity<RegisterRequest> registerTest(@Valid @RequestBody RegisterRequest registerRequest) {

        return ResponseEntity.ok(registerRequest);
    }



}
