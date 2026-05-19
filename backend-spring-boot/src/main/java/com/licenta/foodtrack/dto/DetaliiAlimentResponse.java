package com.licenta.foodtrack.dto;

import com.fasterxml.jackson.annotation.JsonProperty;

public record DetaliiAlimentResponse(
        @JsonProperty("densitate_calorica")
        Double densitateCalorica,
        @JsonProperty("protein_percent")
        Double proteinPercent,
        @JsonProperty("carbohydrates_percent")
        Double carbohydratesPercent,
        @JsonProperty("fat_percent")
        Double fatPercent
) {
}
