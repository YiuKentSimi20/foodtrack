package com.licenta.foodtrack.mapper;

import com.licenta.foodtrack.dto.ObiectivDto;
import com.licenta.foodtrack.model.Obiectiv;
import org.springframework.stereotype.Component;

@Component
public class ObiectivMapper {
    public Obiectiv toObiectiv(ObiectivDto dto) {
        Obiectiv obiectiv = new Obiectiv();

        obiectiv.setCalories(dto.obiectivCaloriiZi());
        obiectiv.setProtein(dto.obiectivProteineZi());
        obiectiv.setCarbohydrates(dto.obiectivCarbohidratiZi());
        obiectiv.setFat(dto.obiectivGrasimiZi());
        obiectiv.setDataStart(dto.data());

        return obiectiv;
    }

    public ObiectivDto toObiectivDto(Obiectiv obiectiv) {

        return new ObiectivDto(
                obiectiv.getDataStart(),
                obiectiv.getCalories(),
                obiectiv.getProtein(),
                obiectiv.getCarbohydrates(),
                obiectiv.getFat()
        );
    }
}
