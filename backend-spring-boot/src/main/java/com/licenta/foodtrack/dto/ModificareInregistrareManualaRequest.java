package com.licenta.foodtrack.dto;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.PositiveOrZero;

public record ModificareInregistrareManualaRequest(
        @NotNull(message = "id is required")
        Long id,
        @Positive
        Double grams,

        @PositiveOrZero(message = "calories must be a positive number")
        Double calories,
        @PositiveOrZero(message = "fat must be a positive number")
        Double fat,
        @PositiveOrZero(message = "carbohydrates must be a positive number")
        Double carbohydrates,
        @PositiveOrZero(message = "fiber must be a positive number")
        Double fiber,
        @PositiveOrZero(message = "protein must be a positive number")
        Double protein
) {
}
