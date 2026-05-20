package com.licenta.foodtrack.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.validation.constraints.NotNull;

import java.time.LocalDate;

public record HealthConnectRequest(
        @NotNull
        @JsonFormat(pattern = "yyyy-MM-dd")
        @JsonProperty("data_activitate")
        LocalDate dataActivitate,

        @NotNull
        @JsonProperty("numar_pasi")
        Integer numarPasi,

        @NotNull
        @JsonProperty("calorii_arse")
        Double caloriiArse
) {
}
