package com.licenta.foodtrack.mapper;

import com.licenta.foodtrack.dto.AlimentDto;
import com.licenta.foodtrack.dto.CreateAlimentRequest;
import com.licenta.foodtrack.dto.OffProduct;
import com.licenta.foodtrack.model.Aliment;
import com.licenta.foodtrack.model.CategorieAliment;
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
        aliment.setCategorie(CategorieAliment.ALTELE);

        return aliment;
    }

    public Aliment toAliment(CreateAlimentRequest request) {

        Aliment aliment = new Aliment();

        aliment.setProductName(request.productName());
        aliment.setBrands(request.brands());
        aliment.setCode(request.code());
        aliment.setEnergyKcal100g(request.energyKcal100g());
        aliment.setFat100g(request.fat100g());
        aliment.setSaturatedFat100g(request.saturatedFat100g());
        aliment.setCarbohydrates100g(request.carbohydrates100g());
        aliment.setSugars100g(request.sugars100g());
        aliment.setFiber100g(request.fiber100g());
        aliment.setProtein100g(request.protein100g());
        aliment.setSalt100g(request.salt100g());
        aliment.setNutritionScore(NutritionScore.UNKNOWN);
        aliment.setCategorie(request.categorie());

        return aliment;
    }

    public AlimentDto toDto(Aliment aliment) {
        return new AlimentDto(
                aliment.getId(),
                aliment.getProductName(),
                aliment.getBrands(),
                aliment.getCode(),
                aliment.getIsValidated(),
                aliment.getEnergyKcal100g(),
                aliment.getEnergyKj100g(),
                aliment.getFat100g(),
                aliment.getSaturatedFat100g(),
                aliment.getCarbohydrates100g(),
                aliment.getSugars100g(),
                aliment.getFiber100g(),
                aliment.getProtein100g(),
                aliment.getSalt100g(),
                aliment.getNutritionScore(),
                aliment.getCategorie()
        );
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
