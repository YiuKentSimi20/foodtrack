package com.licenta.foodtrack.mapper;

import com.licenta.foodtrack.dto.CategorieMasaDto;
import com.licenta.foodtrack.model.CategorieMasa;
import org.springframework.stereotype.Component;

@Component
public class CategorieMasaMapper {

    public CategorieMasaDto toDto(CategorieMasa categorieMasa) {

        return new CategorieMasaDto(
                categorieMasa.getId(),
                categorieMasa.getNume(),
                categorieMasa.getNumarOrdine(),
                categorieMasa.getIsActive()
        );
    }

}
