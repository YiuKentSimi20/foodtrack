package com.licenta.foodtrack.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.licenta.foodtrack.model.CategorieActivitate;
import com.licenta.foodtrack.model.SursaDate;
import com.licenta.foodtrack.validation.annotations.EnumNamePattern;

import java.time.LocalDate;

public record InregistrareActivitateFizicaResponse(
        Long id,

        String nume,

        @JsonProperty("data_activitate")
        LocalDate dataActivitate,

        Double met,

        @JsonProperty("durata_min")
        Double durataMin,

        @JsonProperty("calorii_arse")
        Double caloriiArse,

        @JsonProperty("numar_pasi")
        Integer numarPasi,

        @JsonProperty("utilizator_kg")
        Double utilizatorKg,

        CategorieActivitate categorie,

        @JsonProperty("sursa_date")
        SursaDate sursaDate,

        String notite
) {
}
