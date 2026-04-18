package com.licenta.foodtrack.mapper;


import com.licenta.foodtrack.dto.MasaResponse;
import com.licenta.foodtrack.model.Masa;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class MasaMapper {

    private final InregistrareAlimentMapper inregistrareAlimentMapper;

    public MasaResponse toResponse(Masa masa){
        return new MasaResponse(
                masa.getId(),
                masa.getNume(),
                masa.getDataMesei(),
                masa.getOraMesei(),
                masa.getNotiteMasa(),
                masa.getTotalEnergyKcal(),
                masa.getTotalEnergyKj(),
                masa.getTotalFat(),
                masa.getFatCaloriesPercent(),
                masa.getTotalSaturatedFat(),
                masa.getTotalCarbohydrates(),
                masa.getCarbohydratesCaloriesPercent(),
                masa.getTotalSugars(),
                masa.getTotalFiber(),
                masa.getTotalProtein(),
                masa.getProteinCaloriesPercent(),
                masa.getTotalSalt(),
                masa.getInregistrariAlimente().stream().map(inregistrareAlimentMapper::toResponse).toList()
        );

    }

}
