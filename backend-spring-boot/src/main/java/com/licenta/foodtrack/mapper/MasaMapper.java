package com.licenta.foodtrack.mapper;


import com.licenta.foodtrack.dto.MasaResponse;
import com.licenta.foodtrack.model.Masa;
import com.licenta.foodtrack.util.MacroProcentsCalculator;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class MasaMapper {

    private final InregistrareAlimentMapper inregistrareAlimentMapper;

    public MasaResponse toResponse(Masa masa) {

        MacroProcentsCalculator.MacroPercents macroPercents = MacroProcentsCalculator.calcPercentsSumOne(
                masa.getTotalFat(),
                masa.getTotalCarbohydrates(),
                masa.getTotalProtein()
        );

        return new MasaResponse(
                masa.getId(),
                masa.getCategorieMasa().getId(),
                masa.getDataMesei(),
                masa.getOraMesei(),
                masa.getNotiteMasa(),
                masa.calculateTotalGrams(),
                masa.getTotalEnergyKcal(),
                masa.getTotalEnergyKj(),
                masa.getTotalFat(),
                macroPercents.fatPercent(),
                masa.getTotalSaturatedFat(),
                masa.getTotalCarbohydrates(),
                macroPercents.carbsPercent(),
                masa.getTotalSugars(),
                masa.getTotalFiber(),
                masa.getTotalProtein(),
                macroPercents.proteinPercent(),
                masa.getTotalSalt(),
                masa.getInregistrariAlimente().stream().map(inregistrareAlimentMapper::toResponse).toList()
        );

    }

}
