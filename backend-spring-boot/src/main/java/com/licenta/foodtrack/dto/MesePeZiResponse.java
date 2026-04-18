package com.licenta.foodtrack.dto;

import com.fasterxml.jackson.annotation.JsonProperty;

import java.time.LocalDate;
import java.util.List;

public record MesePeZiResponse(
        LocalDate data,
        List<MasaResponse> mese,

        @JsonProperty("obiectiv_calorii")
        Double obiectivCalorii,
        @JsonProperty("obiectiv_proteine")
        Double obiectivProteine,
        @JsonProperty("obiectiv_carbohidrati")
        Double obiectivCarbohidrati,
        @JsonProperty("obiectiv_grasimi")
        Double obiectivGrasimi,
        @JsonProperty("energy_kcal_total")
        Double energyKcalTotal,
        @JsonProperty("energy_kj_total")
        Double energyKjTotal,
        @JsonProperty("fat_total")
        Double fatTotal,
        @JsonProperty("fat_percent")
        Double fatPercent,
        @JsonProperty("saturated_fat_total")
        Double saturatedFatTotal,
        @JsonProperty("carbohidrati_total")
        Double carbohydratesTotal,
        @JsonProperty("carbohydrates_percent")
        Double carbohydratesPercent,
        @JsonProperty("sugars_total")
        Double sugarsTotal,
        @JsonProperty("fiber_total")
        Double fiberTotal,
        @JsonProperty("proteine_total")
        Double proteineTotal,
        @JsonProperty("protein_percent")
        Double proteinPercent,
        @JsonProperty("salt_total")
        Double saltTotal

        // Obiectiv calorii, nutrienti
) {
}
