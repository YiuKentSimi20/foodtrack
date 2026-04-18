package com.licenta.foodtrack.dto;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;

public record ModificareInregistrareManualaRequest(
        @NotNull(message = "id is required")
        Long id,
        @Positive
        Double grams,

        @Positive(message = "calories must be a positive number")
        Double calories,
        @Positive(message = "fat must be a positive number")
        Double fat,
        @Positive(message = "carbohydrates must be a positive number")
        Double carbohydrates,
        @Positive(message = "fiber must be a positive number")
        Double fiber,
        @Positive(message = "protein must be a positive number")
        Double protein
) {
}
