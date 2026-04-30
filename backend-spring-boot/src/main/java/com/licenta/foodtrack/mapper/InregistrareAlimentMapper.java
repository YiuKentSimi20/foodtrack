package com.licenta.foodtrack.mapper;

import com.licenta.foodtrack.dto.InregistrareAlimentRequest;
import com.licenta.foodtrack.dto.InregistrareAlimentResponse;
import com.licenta.foodtrack.dto.InregistrareManualaRequest;
import com.licenta.foodtrack.model.Aliment;
import com.licenta.foodtrack.model.InregistrareAliment;
import com.licenta.foodtrack.model.TipInregistrare;
import org.springframework.stereotype.Component;

@Component
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
        inregistrareAliment.setCategorie(aliment.getCategorie());

        return inregistrareAliment;
    }

    public InregistrareAliment toInregistrareAliment(InregistrareManualaRequest request) {

        InregistrareAliment inregistrareAliment = new InregistrareAliment();
        inregistrareAliment.setProductName("Intrare manuala");
        if(request.grams() != null) {
            inregistrareAliment.setGrams(request.grams());
        } else {
            inregistrareAliment.setGrams(1d);
        }
        inregistrareAliment.setEnergyKcal100g(request.calories());
        inregistrareAliment.setFat100g(request.fat());
        inregistrareAliment.setCarbohydrates100g(request.carbohydrates());
        inregistrareAliment.setProtein100g(request.protein());
        if(request.fiber() != null) {
            inregistrareAliment.setFiber100g(request.fiber());
        }
        inregistrareAliment.setTipInregistrare(TipInregistrare.MANUAL);

        return  inregistrareAliment;
    }

    public InregistrareAlimentResponse toResponse(InregistrareAliment inregistrareAliment) {
        return new InregistrareAlimentResponse(
                inregistrareAliment.getId(),
                inregistrareAliment.getGrams(),
                inregistrareAliment.getProductName(),
                inregistrareAliment.getBrands(),
                inregistrareAliment.getCode(),
                inregistrareAliment.getEnergyKcal100g(),
                inregistrareAliment.getTotalEnergyKcal(),
                inregistrareAliment.getEnergyKj100g(),
                inregistrareAliment.getTotalEnergyKj(),
                inregistrareAliment.getFat100g(),
                inregistrareAliment.getTotalFat(),
                inregistrareAliment.getFatCaloriesPercent(),
                inregistrareAliment.getSaturatedFat100g(),
                inregistrareAliment.getTotalSaturatedFat(),
                inregistrareAliment.getCarbohydrates100g(),
                inregistrareAliment.getTotalCarbohydrates(),
                inregistrareAliment.getCarbohydratesCaloriesPercent(),
                inregistrareAliment.getSugars100g(),
                inregistrareAliment.getTotalSugars(),
                inregistrareAliment.getFiber100g(),
                inregistrareAliment.getTotalFiber(),
                inregistrareAliment.getProtein100g(),
                inregistrareAliment.getTotalProtein(),
                inregistrareAliment.getProteinCaloriesPercent(),
                inregistrareAliment.getSalt100g(),
                inregistrareAliment.getTotalSalt(),
                inregistrareAliment.getNutritionScore(),
                inregistrareAliment.getCategorie(),
                inregistrareAliment.getTipInregistrare(),
                inregistrareAliment.getMasa().getId()

        );
    }
}
