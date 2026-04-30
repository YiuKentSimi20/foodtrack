package com.licenta.foodtrack.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotNull;

import java.util.List;

public record UpdateCategoriiMeseRequest(
        @NotNull(message = "categorii_mese is required")
        @JsonProperty("categorii_mese")
        List<@Valid CategorieMasaDto> categoriiMese
) {
}
