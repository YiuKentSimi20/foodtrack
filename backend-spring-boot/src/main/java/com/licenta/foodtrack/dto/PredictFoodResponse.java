package com.licenta.foodtrack.dto;

public record PredictFoodResponse(
        String status,
        String mancare,
        Double siguranta
) {
}
