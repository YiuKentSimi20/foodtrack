package com.licenta.foodtrack.mapper;


import com.licenta.foodtrack.dto.ActivitateFizicaDto;
import com.licenta.foodtrack.model.ActivitateFizica;
import org.springframework.stereotype.Component;

@Component
public class ActivitateFizicaMapper {

    public ActivitateFizicaDto toDto(ActivitateFizica activitateFizica) {

        return new ActivitateFizicaDto(
                activitateFizica.getId(),
                activitateFizica.getNume(),
                activitateFizica.getMet(),
                activitateFizica.getCategorie()
        );
    }

}
