package com.licenta.foodtrack.dto;

import com.fasterxml.jackson.annotation.JsonProperty;

public record OffProduct(
        String code,

        @JsonProperty("product_name")
        String productName,

        OffNutriments nutriments,

        @JsonProperty("nutrition_grades")
        String nutritionScore
) {
}

