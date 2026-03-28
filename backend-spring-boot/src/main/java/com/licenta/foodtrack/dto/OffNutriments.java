package com.licenta.foodtrack.dto;

import com.fasterxml.jackson.annotation.JsonProperty;

public record OffNutriments(
        @JsonProperty("energy-kcal_100g")
        Double energyKcal100g,

        @JsonProperty("energy-kj_100g")
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

        @JsonProperty("proteins_100g")
        Double proteins100g,

        @JsonProperty("salt_100g")
        Double salt100g


) {
}
