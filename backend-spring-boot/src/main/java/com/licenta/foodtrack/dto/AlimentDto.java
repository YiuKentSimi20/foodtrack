package com.licenta.foodtrack.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.licenta.foodtrack.model.CategorieAliment;
import com.licenta.foodtrack.model.NutritionScore;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;

import java.util.UUID;

public record AlimentDto(
        Long id,
        @JsonProperty("product_name")
        String productName,
        String brands,
        String code,
        @JsonProperty("is_validated")
        Boolean isValidated,
        @JsonProperty("energy_kcal_100g")
        Double energyKcal100g,
        @JsonProperty("energy_kj_100g")
        Double energyKj100g,
        @JsonProperty("fat_100g")
        Double fat100g,
        @JsonProperty("saturated_fat_100g")
        Double saturatedFat100g,
        @JsonProperty("carbohydrates_100g")
        Double carbohydrates100g,
        @JsonProperty("sugars_100g")
        Double sugars100g,
        @JsonProperty("fiber_100g")
        Double fiber100g,
        @JsonProperty("protein_100g")
        Double protein100g,
        @JsonProperty("salt_100g")
        Double salt100g,
        @JsonProperty("nutrition_score")
        NutritionScore nutritionScore,
        CategorieAliment categorie

) {
}
