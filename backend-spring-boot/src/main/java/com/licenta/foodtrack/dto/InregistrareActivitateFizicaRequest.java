package com.licenta.foodtrack.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.validation.constraints.NotNull;

import java.time.LocalDate;

public record InregistrareActivitateFizicaRequest(
        @NotNull
        Long id,

        @NotNull
        @JsonFormat(pattern = "yyyy-MM-dd")
        @JsonProperty("data_activitate")
        LocalDate dataActivitate,

        @NotNull
        @JsonProperty("durata_min")
        Double durataMin,

        String notite
) {
}
