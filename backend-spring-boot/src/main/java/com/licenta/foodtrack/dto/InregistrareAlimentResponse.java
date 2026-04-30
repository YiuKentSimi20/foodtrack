package com.licenta.foodtrack.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.licenta.foodtrack.model.CategorieAliment;
import com.licenta.foodtrack.model.NutritionScore;
import com.licenta.foodtrack.model.TipInregistrare;
import jakarta.validation.constraints.NotNull;

public record InregistrareAlimentResponse(
        Long id,
        Double grams,

        @JsonProperty("product_name")
        String productName,

        String brands,

        String code,

        @JsonProperty("energy_kcal_100g")
        Double energyKcal100g,

        @JsonProperty("energy_kcal_total")
        Double energyKcalTotal,

        @JsonProperty("energy_kj_100g")
        Double energyKj100g,

        @JsonProperty("energy_kj_total")
        Double energyKjTotal,

        @JsonProperty("fat_100g")
        Double fat100g,

        @JsonProperty("fat_total")
        Double fatTotal,

        @JsonProperty("fat_percent")
        Double fatPercent,

        @JsonProperty("saturated_fat_100g")
        Double saturatedFat100g,

        @JsonProperty("saturated_fat_total")
        Double saturatedFatTotal,

        @JsonProperty("carbohydrates_100g")
        Double carbohydrates100g,

        @JsonProperty("carbohydrates_total")
        Double carbohydratesTotal,

        @JsonProperty("carbohydrates_percent")
        Double carbohydratesPercent,

        @JsonProperty("sugars_100g")
        Double sugars100g,

        @JsonProperty("sugars_total")
        Double sugarsTotal,

        @JsonProperty("fiber_100g")
        Double fiber100g,

        @JsonProperty("fiber_total")
        Double fiberTotal,

        @JsonProperty("protein_100g")
        Double protein100g,

        @JsonProperty("protein_total")
        Double proteinTotal,

        @JsonProperty("protein_percent")
        Double proteinPercent,

        @JsonProperty("salt_100g")
        Double salt100g,

        @JsonProperty("salt_total")
        Double saltTotal,

        NutritionScore nutritionScore,

        CategorieAliment categorie,

        @NotNull(message = "tip_inregistrare is required")
        @JsonProperty("tip_inregistrare")
        TipInregistrare tipInregistrare,

        @JsonProperty("masa_id")
        Long masaId
)
{
}
