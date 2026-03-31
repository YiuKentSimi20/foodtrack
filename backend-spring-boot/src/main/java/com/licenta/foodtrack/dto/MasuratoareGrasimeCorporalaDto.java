package com.licenta.foodtrack.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.validation.constraints.*;

import java.time.LocalDate;

public record MasuratoareGrasimeCorporalaDto(
        @NotNull(message = "grasime_corporala_procent is required")
        @Positive(message = "Grasimea corporală procent trebuie să fie un număr pozitiv")
        @JsonProperty("grasime_corporala_procent")
        Double grasimeCorporalaProcent,

        @NotNull(message = "data_masuratoare is required")
        @PastOrPresent(message = "data_masuratoare trebuie sa fie in trecut sau acum")
        @JsonProperty("data_masuratoare")
        @JsonFormat(pattern = "yyyy-MM-dd")
        LocalDate dataMasuratoare

) {

}
