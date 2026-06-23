package com.licenta.foodtrack.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.PositiveOrZero;

import java.time.LocalDate;

public record InregistrareManualaRequest(

        @JsonProperty("categorie_masa_id")
        @NotNull(message = "categorie_masa_id is required")
        Long categorieMasaId,
        @NotNull(message = "data is required")
        @JsonFormat(pattern = "yyyy-MM-dd")
        LocalDate data,

        @PositiveOrZero
        Double grams,

        @PositiveOrZero(message = "energy_kcal must be a positive number")
        @JsonProperty("energy_kcal")
        Double energyKcal,
        @NotNull(message = "fat is required")
        @PositiveOrZero(message = "fat must be a positive number")
        Double fat,
        @NotNull(message = "carbohydrates is required")
        @PositiveOrZero(message = "carbohydrates must be a positive number")
        Double carbohydrates,
        @PositiveOrZero(message = "fiber must be a positive number")
        Double fiber,
        @NotNull(message = "protein is required")
        @PositiveOrZero
        Double protein
) {
}
