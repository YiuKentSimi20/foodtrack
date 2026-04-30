package com.licenta.foodtrack.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public record CategorieMasaDto(
        @NotNull(message = "id is required")
        @JsonProperty("id")
        Long id,

        @NotBlank(message = "nume is required")
        @JsonProperty("nume")
        String nume,

        @NotNull(message = "numar_ordine is required")
        @JsonProperty("numar_ordine")
        Integer numarOrdine,

        @NotNull(message = "is_active is required")
        @JsonProperty("is_active")
        Boolean isActive
) {
}
