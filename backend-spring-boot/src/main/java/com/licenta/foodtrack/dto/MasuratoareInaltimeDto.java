package com.licenta.foodtrack.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.validation.constraints.*;

import java.time.LocalDate;

public record MasuratoareInaltimeDto(
        @NotNull(message = "inaltime_cm is required")
        @Positive(message = "Înălțimea în cm trebuie să fie un număr pozitiv")
        @JsonProperty("inaltime_cm")
        Double inaltimeCm,

        @NotNull(message = "data_masuratoare is required")
        @PastOrPresent(message = "data_masuratoare trebuie sa fie in trecut sau acum")
        @JsonProperty("data_masuratoare")
        @JsonFormat(pattern = "yyyy-MM-dd")
        LocalDate dataMasuratoare

) {

}
