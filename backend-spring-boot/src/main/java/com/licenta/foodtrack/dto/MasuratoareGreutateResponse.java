package com.licenta.foodtrack.dto;

import com.fasterxml.jackson.annotation.JsonProperty;

import java.time.LocalDate;

public record MasuratoareGreutateResponse(
        Long id,
        @JsonProperty("greutate_kg")
        Double greutateKg,
        LocalDate date
) {
}
