package com.licenta.foodtrack.auth;

import jakarta.validation.constraints.NotBlank;

public record AuthenticationRequest(
        @NotBlank(message = "identifier is required")
        String identifier,
        @NotBlank(message = "password is required")
        String password
) {
}
