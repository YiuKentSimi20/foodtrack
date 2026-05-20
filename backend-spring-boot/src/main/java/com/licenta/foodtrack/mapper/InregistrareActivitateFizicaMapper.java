package com.licenta.foodtrack.mapper;

import com.licenta.foodtrack.dto.InregistrareActivitateFizicaRequest;
import com.licenta.foodtrack.dto.InregistrareActivitateFizicaResponse;
import com.licenta.foodtrack.model.ActivitateFizica;
import com.licenta.foodtrack.model.InregistrareActivitateFizica;
import org.springframework.stereotype.Component;

@Component
public class InregistrareActivitateFizicaMapper {

    public InregistrareActivitateFizica toInregistrareActivitateFizica(
            ActivitateFizica activitateFizica,
            InregistrareActivitateFizicaRequest request ) {

        InregistrareActivitateFizica inregistrareActivitateFizica = new InregistrareActivitateFizica();

        inregistrareActivitateFizica.setNume(activitateFizica.getNume());
        inregistrareActivitateFizica.setDataActivitate(request.dataActivitate());
        inregistrareActivitateFizica.setDurataMin(request.durataMin());
        inregistrareActivitateFizica.setMet(activitateFizica.getMet());
        inregistrareActivitateFizica.setCategorie(activitateFizica.getCategorie());
        inregistrareActivitateFizica.setNotite(request.notite());

        return inregistrareActivitateFizica;
    }

    public InregistrareActivitateFizicaResponse toResponse(InregistrareActivitateFizica inregistrareActivitateFizica) {

        return new InregistrareActivitateFizicaResponse(
                inregistrareActivitateFizica.getId(),
                inregistrareActivitateFizica.getNume(),
                inregistrareActivitateFizica.getDataActivitate(),
                inregistrareActivitateFizica.getMet(),
                inregistrareActivitateFizica.getDurataMin(),
                inregistrareActivitateFizica.getCaloriiArse(),
                inregistrareActivitateFizica.getNumarPasi(),
                inregistrareActivitateFizica.getCategorie(),
                inregistrareActivitateFizica.getSursaDate(),
                inregistrareActivitateFizica.getNotite()
        );
    }

}
