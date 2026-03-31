package com.licenta.foodtrack.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.validation.constraints.*;

import java.time.LocalDate;


public record MasuratoareGreutateDto(
        @NotNull(message = "greutate_kg is required")
        @Positive(message = "Greutatea în kg trebuie să fie un număr pozitiv")
        @JsonProperty("greutate_kg")
        Double greutatekg,

        @NotNull(message = "data_masuratoare is required")
        @PastOrPresent(message = "data_masuratoare trebuie sa fie in trecut sau acum")
        @JsonProperty("data_masuratoare")
        @JsonFormat(pattern = "yyyy-MM-dd")
        LocalDate dataMasuratoare

) {
}
