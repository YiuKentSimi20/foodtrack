package com.licenta.foodtrack.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;

import java.time.LocalDate;

public record InregistrareManualaRequest(

        @JsonProperty("nume_masa")
        @NotBlank(message = "nume_masa is required")
        String numeMasa,
        @NotNull(message = "data is required")
        @JsonFormat(pattern = "yyyy-MM-dd")
        LocalDate data,

        @Positive
        Double grams,

        @Positive
        Double calories,
        @NotNull(message = "fat is required")
        @Positive(message = "fat must be a positive number")
        Double fat,
        @NotNull(message = "carbohydrates is required")
        @Positive(message = "carbohydrates must be a positive number")
        Double carbohydrates,
        @Positive(message = "fiber must be a positive number")
        Double fiber,
        @NotNull(message = "protein is required")
        Double protein
) {
}
