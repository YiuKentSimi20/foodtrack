package com.licenta.foodtrack.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;

public record ModificareGramajInregistrareAlimentRequest(
        @NotNull
        @JsonProperty("id_inregistrare")
        Long idInregistrare,
        @Positive
        @NotNull
        Double grams
) {

}
