package com.licenta.foodtrack.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.PastOrPresent;

import java.time.LocalDate;

public record ObiectivDto(
        @NotNull(message = "data is required")
        @PastOrPresent(message = "data trebuie sa fie in trecut sau acum")
        @JsonProperty("data")
        @JsonFormat(pattern = "yyyy-MM-dd")
        LocalDate data,
        @JsonProperty("obiectiv_calorii_zi")
        Double obiectivCaloriiZi,
        @JsonProperty("obiectiv_proteine_zi")
        Double obiectivProteineZi,
        @JsonProperty("obiectiv_carbohidrati_zi")
        Double obiectivCarbohidratiZi,
        @JsonProperty("obiectiv_grasimi_zi")
        Double obiectivGrasimiZi

) {
}
