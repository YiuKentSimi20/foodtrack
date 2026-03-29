package com.licenta.foodtrack.mapper;

import com.licenta.foodtrack.dto.OffProduct;
import com.licenta.foodtrack.model.Aliment;
import com.licenta.foodtrack.model.NutritionScore;
import org.springframework.stereotype.Component;

@Component
public class AlimentMapper {
    public Aliment toAliment(OffProduct offProduct) {

        Aliment aliment = new Aliment();

        aliment.setProductName(offProduct.productName());
        aliment.setBrands(offProduct.brands());
        aliment.setCode(offProduct.code());
        aliment.setIsValidated(true);
        if(offProduct.nutriments() != null) {
            aliment.setEnergyKcal100g(offProduct.nutriments().energyKcal100g());
            aliment.setEnergyKj100g(offProduct.nutriments().energyKj100g());
            aliment.setFat100g(offProduct.nutriments().fat100g());
            aliment.setSaturatedFat100g(offProduct.nutriments().saturatedFat100g());
            aliment.setCarbohydrates100g(offProduct.nutriments().carbohydrates100g());
            aliment.setSugars100g(offProduct.nutriments().sugars100g());
            aliment.setFiber100g(offProduct.nutriments().fiber100g());
            aliment.setProtein100g(offProduct.nutriments().proteins100g());
            aliment.setSalt100g(offProduct.nutriments().salt100g());
        }
        aliment.setNutritionScore(mapNutritionScore(offProduct.nutritionScore()));

        return aliment;
    }

    private NutritionScore mapNutritionScore(String score) {
        if (score == null || score.isBlank()) {
            return NutritionScore.UNKNOWN;
        }

        return switch (score) {
            case "a" -> NutritionScore.A;
            case "b" -> NutritionScore.B;
            case "c" -> NutritionScore.C;
            case "d" -> NutritionScore.D;
            case "e" -> NutritionScore.E;
            default -> NutritionScore.UNKNOWN;
        };
    }
}
