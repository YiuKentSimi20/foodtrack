package com.licenta.foodtrack.mapper;

import com.licenta.foodtrack.model.Aliment;
import com.licenta.foodtrack.model.InregistrareAliment;

public class InregistrareAlimentMapper {
    public InregistrareAliment toInregistrareAliment(Aliment aliment, Double grams) {
        InregistrareAliment inregistrareAliment = new InregistrareAliment();
        inregistrareAliment.setGrams(grams);
        inregistrareAliment.setProductName(aliment.getProductName());
        inregistrareAliment.setBrands(aliment.getBrands());
        inregistrareAliment.setCode(aliment.getCode());
        inregistrareAliment.setEnergyKcal100g(aliment.getEnergyKcal100g());
        inregistrareAliment.setEnergyKj100g(aliment.getEnergyKj100g());
        inregistrareAliment.setFat100g(aliment.getFat100g());
        inregistrareAliment.setSaturatedFat100g(aliment.getSaturatedFat100g());
        inregistrareAliment.setCarbohydrates100g(aliment.getCarbohydrates100g());
        inregistrareAliment.setSugars100g(aliment.getSugars100g());
        inregistrareAliment.setFiber100g(aliment.getFiber100g());
        inregistrareAliment.setProtein100g(aliment.getProtein100g());
        inregistrareAliment.setSalt100g(aliment.getSalt100g());
        inregistrareAliment.setNutritionScore(aliment.getNutritionScore());

        return inregistrareAliment;
    }
}
