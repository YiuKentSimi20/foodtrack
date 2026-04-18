package com.licenta.foodtrack.dto;

import com.fasterxml.jackson.annotation.JsonProperty;

import java.time.LocalDate;

public record MasuratoareInaltimeResponse(
        Long id,
        @JsonProperty("inaltime_cm")
        Double inaltimeCm,
        LocalDate date
) {
}
