package com.licenta.foodtrack.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Positive;


public record MasuratoareGreutateDto(
        @NotNull(message = "greutate_kg is required")
        @Positive(message = "Greutatea în kg trebuie să fie un număr pozitiv")
        @JsonProperty("greutate_kg")
        Double greutatekg,

        @NotBlank(message = "data_masuratoare is required")
        @JsonProperty("data_masuratoare")
        @Pattern(regexp = "^\\d{4}-\\d{2}-\\d{2}$", message = "Data nasterii must be yyyy-MM-dd")
        String dataMasuratoare,

        @JsonProperty("user_id")
        Long userId
) {
}
