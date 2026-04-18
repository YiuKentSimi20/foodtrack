package com.licenta.foodtrack.dto;

import com.fasterxml.jackson.annotation.JsonProperty;

import java.time.LocalDate;

public record MasuratoareGrasimeCorporalaResponse(
        Long id,
        @JsonProperty("grasime_corporala_procent")
        Double grasimeCorporalaProcent,
        LocalDate date
) {
}
