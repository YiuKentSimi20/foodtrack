package com.licenta.foodtrack.service;


import com.licenta.foodtrack.auth.AuthenticationRequest;
import com.licenta.foodtrack.auth.AuthenticationResponse;
import com.licenta.foodtrack.auth.RegisterRequest;
import com.licenta.foodtrack.config.JwtService;
import com.licenta.foodtrack.mapper.UtilizatorMapper;
import com.licenta.foodtrack.model.RolUtilizator;
import com.licenta.foodtrack.model.Utilizator;
import com.licenta.foodtrack.repository.UtilizatorRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class AuthenticationService {

    private final PasswordEncoder passwordEncoder;
    private final UtilizatorMapper utilizatorMapper;
    private final UtilizatorRepository utilizatorRepository;
    private final JwtService jwtService;
    private final AuthenticationManager authenticationManager;

    public AuthenticationResponse register(RegisterRequest registerRequest) {
        Utilizator utilizator = utilizatorMapper.toUtilizator(registerRequest);
        utilizator.setRole(RolUtilizator.USER);
        utilizator.setPassword(passwordEncoder.encode(registerRequest.password()));
        utilizator.initCategoriiMeseDefaultIfEmpty();

        utilizatorRepository.save(utilizator);

        Map<String, Object> claims = new HashMap<>();
        claims.put("uid", utilizator.getId());
        claims.put("role", utilizator.getRole());
        claims.put("email", utilizator.getEmail());

        var jwtToken = jwtService.generateToken(claims,utilizator);

        return AuthenticationResponse.builder()
                .token(jwtToken)
                .build();
    }

    public AuthenticationResponse login(AuthenticationRequest authenticationRequest) {
        authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        authenticationRequest.identifier(),
                        authenticationRequest.password()
                )
        );

        var utilizator = utilizatorRepository.findByUsernameOrEmail(authenticationRequest.identifier(), authenticationRequest.identifier())
                .orElseThrow();

        var jwtToken = jwtService.generateToken(utilizator);

        return AuthenticationResponse.builder()
                .token(jwtToken)
                .build();
    }


}
