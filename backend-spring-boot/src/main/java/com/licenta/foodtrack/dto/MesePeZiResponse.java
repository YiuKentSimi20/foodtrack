package com.licenta.foodtrack.dto;

import com.fasterxml.jackson.annotation.JsonProperty;

import java.time.LocalDate;
import java.util.List;

public record MesePeZiResponse(
        LocalDate data,
        List<MasaResponse> mese,
        @JsonProperty("activitati_fizice")
        List<InregistrareActivitateFizicaResponse> activitatiFizice,
        @JsonProperty("obiectiv_calorii")
        Double obiectivCalorii,
        @JsonProperty("obiectiv_proteine")
        Double obiectivProteine,
        @JsonProperty("obiectiv_proteine_procent")
        Double obiectivProteineProcent,
        @JsonProperty("obiectiv_carbohidrati")
        Double obiectivCarbohidrati,
        @JsonProperty("obiectiv_carbohidrati_procent")
        Double obiectivCarbohidratiProcent,
        @JsonProperty("obiectiv_grasimi")
        Double obiectivGrasimi,
        @JsonProperty("obiectiv_grasimi_procent")
        Double obiectivGrasimiProcent,
        @JsonProperty("grams_total")
        Double gramsTotal,
        @JsonProperty("energy_kcal_total")
        Double energyKcalTotal,
        @JsonProperty("energy_kj_total")
        Double energyKjTotal,
        @JsonProperty("fat_total")
        Double fatTotal,
        @JsonProperty("fat_percent")
        Double fatPercent,
        @JsonProperty("saturated_fat_total")
        Double saturatedFatTotal,
        @JsonProperty("saturated_fat_recommended_grams")
        Double saturatedFatRecommended_grams,
        @JsonProperty("saturated_fat_percent")
        Double saturatedFatPercent,
        @JsonProperty("carbohidrati_total")
        Double carbohydratesTotal,
        @JsonProperty("carbohydrates_percent")
        Double carbohydratesPercent,
        @JsonProperty("sugars_total")
        Double sugarsTotal,
        @JsonProperty("free_sugars_total")
        Double freeSugarsTotal,
        @JsonProperty("free_sugars_percent")
        Double freeSugarsPercent,
        @JsonProperty("free_sugars_recommended_grams")
        Double freeSugarsRecommendedGrams,
        @JsonProperty("fiber_total")
        Double fiberTotal,
        @JsonProperty("fiber_recommended_grams")
        Double fiberRecommendedGrams,
        @JsonProperty("fiber_message")
        String fiberMessage,
        @JsonProperty("proteine_total")
        Double proteineTotal,
        @JsonProperty("protein_percent")
        Double proteinPercent,
        @JsonProperty("salt_total")
        Double saltTotal,
        @JsonProperty("salt_recommended_grams")
        Double saltRecommendedGrams,
        @JsonProperty("vegetables_total_grams")
        Double vegetablesTotalGrams,
        @JsonProperty("fruits_total_grams")
        Double fruitsTotalGrams,
        @JsonProperty("fruits_and_vegetables_recommended_grams")
        Double fruitsAndVegetablesRecommendedGrams,
        @JsonProperty("fruits_and_vegetables_message")
        String fruitsAndVegetablesMessage,
        @JsonProperty("calorii_arse")
        Double caloriiArse,
        @JsonProperty("calorii_nete")
        Double caloriiNete
) {
}
