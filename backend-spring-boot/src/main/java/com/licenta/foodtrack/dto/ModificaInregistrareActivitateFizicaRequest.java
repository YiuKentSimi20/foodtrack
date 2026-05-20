package com.licenta.foodtrack.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotNull;

public record ModificaInregistrareActivitateFizicaRequest(

        @NotNull
        Long id,

        @NotNull
        @JsonProperty("durata_min")
        Double durataMin,

        String notite
) {
}
