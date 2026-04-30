package com.licenta.foodtrack.service;

import com.licenta.foodtrack.auth.RegisterRequest;
import com.licenta.foodtrack.dto.DatePersonaleResponse;
import com.licenta.foodtrack.dto.ModificaDatePersonaleRequest;
import com.licenta.foodtrack.mapper.UtilizatorMapper;
import com.licenta.foodtrack.model.RolUtilizator;
import com.licenta.foodtrack.model.Utilizator;
import com.licenta.foodtrack.repository.UtilizatorRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.Period;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class UtilizatorService {

    public final UtilizatorRepository utilizatorRepository;

    public DatePersonaleResponse getDatePersonale(UUID id) {

        Utilizator utilizator = utilizatorRepository.findById(id).get();

        return new DatePersonaleResponse(
                utilizator.getUsername(),
                utilizator.getEmail(),
                utilizator.getDataNasterii(),
                Period.between(utilizator.getDataNasterii(), LocalDate.now()).getYears(),
                utilizator.getGen(),
                utilizator.getNivelActivitate(),
                utilizator.calculateBmi(),
                utilizator.calculateBmr(),
                utilizator.calculateTdee()
        );
    }

    public DatePersonaleResponse modificaDatePersonale(ModificaDatePersonaleRequest request, UUID id) {

        Utilizator utilizator = utilizatorRepository.findById(id).get();

        if(request.username()!=null)  {
            utilizator.setUsername(request.username());
        }
        if(request.gen()!=null)  {
            utilizator.setGen(request.gen());
        }
        if(request.dataNasterii()!=null) {
            utilizator.setDataNasterii(request.dataNasterii());
        }
        if(request.nivelActivitate()!=null) {
            utilizator.setNivelActivitate(request.nivelActivitate());
        }
        if(request.dataNasterii()!=null || request.nivelActivitate()!=null) {
            utilizator.setNecesarCaloricMentinere(utilizator.calculateTdee());
        }

        utilizatorRepository.save(utilizator);

        return new DatePersonaleResponse(
                utilizator.getUsername(),
                utilizator.getEmail(),
                utilizator.getDataNasterii(),
                Period.between(utilizator.getDataNasterii(), LocalDate.now()).getYears(),
                utilizator.getGen(),
                utilizator.getNivelActivitate(),
                utilizator.calculateBmi(),
                utilizator.calculateBmr(),
                utilizator.calculateTdee()
        );
    }
}
