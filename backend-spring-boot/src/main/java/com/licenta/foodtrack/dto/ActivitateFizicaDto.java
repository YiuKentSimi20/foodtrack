package com.licenta.foodtrack.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.licenta.foodtrack.model.CategorieActivitate;
import com.licenta.foodtrack.model.SursaDate;

public record ActivitateFizicaDto(
        Long id,
        String nume,
        Double met,
        CategorieActivitate categorie
) {
}
