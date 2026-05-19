package com.licenta.foodtrack.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.PastOrPresent;

import java.time.LocalDate;

public record ObiectivResponse(
        @NotNull(message = "data is required")
        @PastOrPresent(message = "data trebuie sa fie in trecut sau acum")
        @JsonProperty("data")
        @JsonFormat(pattern = "yyyy-MM-dd")
        LocalDate data,
        @JsonProperty("obiectiv_calorii_zi")
        Double obiectivCaloriiZi,
        @JsonProperty("obiectiv_proteine_zi")
        Double obiectivProteineZi,
        @JsonProperty("obiectiv_proteine_procent")
        Double obiectivProteineProcent,
        @JsonProperty("obiectiv_carbohidrati_zi")
        Double obiectivCarbohidratiZi,
        @JsonProperty("obiectiv_carbohidrati_procent")
        Double obiectivCarbohidratiProcent,
        @JsonProperty("obiectiv_grasimi_zi")
        Double obiectivGrasimiZi,
        @JsonProperty("obiectiv_grasimi_procent")
        Double obiectivGrasimiProcent,
        @JsonProperty("proteine_kg_corp")
        Double proteineKgCorp,
        @JsonProperty("carbohidrati_kg_corp")
        Double carbohidratiKgCorp,
        @JsonProperty("grasimi_kg_corp")
        Double grasimiKgCorp,
        @JsonProperty("calorii_nete_zi")
        Double caloriiNeteZi,
        @JsonProperty("modificare_kg_saptamana")
        Double modificareKgSaptamana

) {
}
