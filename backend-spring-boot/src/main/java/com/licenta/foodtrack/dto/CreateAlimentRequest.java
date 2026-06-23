package com.licenta.foodtrack.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.licenta.foodtrack.model.CategorieAliment;
import com.licenta.foodtrack.model.NutritionScore;
import com.licenta.foodtrack.validation.annotations.EnumNamePattern;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.PositiveOrZero;

public record CreateAlimentRequest(
        @JsonProperty("product_name")
        String productName,
        String brands,
        String code,
        @PositiveOrZero
        @NotNull
        @JsonProperty("energy_kcal_100g")
        Double energyKcal100g,
        @PositiveOrZero
        @NotNull
        @JsonProperty("fat_100g")
        Double fat100g,
        @JsonProperty("saturated_fat_100g")
        Double saturatedFat100g,
        @PositiveOrZero
        @NotNull
        @JsonProperty("carbohydrates_100g")
        Double carbohydrates100g,
        @JsonProperty("sugars_100g")
        @PositiveOrZero
        Double sugars100g,
        @PositiveOrZero
        @JsonProperty("fiber_100g")
        Double fiber100g,
        @PositiveOrZero
        @NotNull
        @JsonProperty("protein_100g")
        Double protein100g,
        @PositiveOrZero
        @JsonProperty("salt_100g")
        Double salt100g,

        @EnumNamePattern(
                regexp = "ALTELE|BUTURI|BRANZETURI|CARNE|CEREALE|CONDIMENTE|DULCIURI|FAST_FOOD|FRUCTE|GRASIMI|LACTATE|" +
                        "LEGUME|MANCARE_GATITA|MEZELURI|OUA|PAINE|PERSONAL|PESTE|SEMINTE|SNACKURI|SOSURI|SUPLIMENTE",
                message = "categorie must be one of: ALTELE, BUTURI, BRANZETURI, CARNE, CEREALE, CONDIMENTE, DULCIURI," +
                        " FAST_FOOD, FRUCTE, GRASIMI, LACTATE, LEGUME, MANCARE_GATITA, MEZELURI, OUA, PAINE, PERSONAL, " +
                        "PESTE, SEMINTE, SNACKURI, SOSURI, SUPLIMENTE"
        )
        @JsonProperty("categorie")
        CategorieAliment categorie,

        @JsonProperty("nutrition_score")
        NutritionScore nutritionScore

) {
}
