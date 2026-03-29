package com.licenta.foodtrack.dto;

import com.fasterxml.jackson.annotation.JsonProperty;

public record OffProduct(
        String code,

        @JsonProperty("product_name")
        String productName,

        String brands,

        OffNutriments nutriments,

        @JsonProperty("nutrition_grades")
        String nutritionScore
) {
}

