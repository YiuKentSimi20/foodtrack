package com.licenta.foodtrack.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;


import java.time.LocalDate;

public record InregistrareAlimentRequest(

        @NotNull(message = "nume_masa is required")
        @JsonProperty("categorie_masa_id")
        Long categorieMasaId,

        @NotNull(message = "data is required")
        LocalDate data,

        @NotNull
        @Positive(message = "calorii trebuie să fie un număr pozitiv")
        Double grams,

        @JsonProperty("id_aliment")
        @NotNull
        Long idAliment


) {
}
