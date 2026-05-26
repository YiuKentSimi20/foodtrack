package com.licenta.foodtrack.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.licenta.foodtrack.model.GenUtilizator;
import com.licenta.foodtrack.model.NivelActivitate;

import java.time.LocalDate;

public record DatePersonaleResponse(
        String username,
        String email,
        String rol,
        @JsonProperty("data_nasterii")
        LocalDate dataNasterii,
        Integer varsta,
        GenUtilizator gen,
        @JsonProperty("nivel_activitate")
        NivelActivitate nivelActivitate,
        Double bmi,
        Double bmr,
        Double tdee
) {
}
