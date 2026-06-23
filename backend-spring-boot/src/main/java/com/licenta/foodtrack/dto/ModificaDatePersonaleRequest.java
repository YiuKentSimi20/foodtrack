package com.licenta.foodtrack.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.licenta.foodtrack.model.GenUtilizator;
import com.licenta.foodtrack.model.NivelActivitate;
import com.licenta.foodtrack.validation.annotations.EnumNamePattern;

import java.time.LocalDate;

public record ModificaDatePersonaleRequest(

        @JsonProperty("data_nasterii")
        @JsonFormat(pattern = "yyyy-MM-dd")
        LocalDate dataNasterii,

        @EnumNamePattern(regexp = "M|F|ALTUL", message = "gen must be one of: M, F, ALTUL")
        @JsonProperty("gen")
        GenUtilizator gen,

        @EnumNamePattern(
                regexp = "SEDENTAR|MAI_PUTIN_ACTIV|ACTIV|FOARTE_ACTIV",
                message = "nivel_activitate must be one of: SEDENTAR, MAI_PUTIN_ACTIV, ACTIV, FOARTE_ACTIV"
        )
        @JsonProperty("nivel_activitate")
        NivelActivitate nivelActivitate
) {
}
