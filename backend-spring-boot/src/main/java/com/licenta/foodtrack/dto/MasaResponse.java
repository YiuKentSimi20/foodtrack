package com.licenta.foodtrack.dto;

import com.fasterxml.jackson.annotation.JsonProperty;

import java.time.LocalDate;
import java.util.List;

public record MasaResponse(
        Long id,
        @JsonProperty("categorie_masa_id")
        Long categorieMasaId,
        LocalDate data,
        String ora,
        String notite,

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

        @JsonProperty("carbohydrates_total")
        Double carbohydratesTotal,

        @JsonProperty("carbohydrates_percent")
        Double carbohydratesPercent,

        @JsonProperty("sugars_total")
        Double sugarsTotal,

        @JsonProperty("fiber_total")
        Double fiberTotal,

        @JsonProperty("protein_total")
        Double proteinTotal,

        @JsonProperty("protein_percent")
        Double proteinPercent,

        @JsonProperty("salt_total")
        Double saltTotal,

        List<InregistrareAlimentResponse> alimente
) {
}
