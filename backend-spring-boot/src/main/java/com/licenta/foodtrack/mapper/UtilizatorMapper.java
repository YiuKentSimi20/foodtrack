package com.licenta.foodtrack.mapper;

import com.licenta.foodtrack.auth.RegisterRequest;
import com.licenta.foodtrack.model.GenUtilizator;
import com.licenta.foodtrack.model.NivelActivitate;
import com.licenta.foodtrack.model.Utilizator;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.time.LocalDate;

@Component
@RequiredArgsConstructor
public class UtilizatorMapper {

    public final MasuratoriMapper masuratoriMapper;

    public Utilizator toUtilizator(RegisterRequest registerRequest) {
        Utilizator utilizator = new Utilizator();

        utilizator.setUsername(registerRequest.username());
        utilizator.setEmail(registerRequest.email());
        utilizator.setGen(registerRequest.gen());
        //utilizator.setDataNasterii(LocalDate.parse(registerRequest.dataNasterii()));
        utilizator.setDataNasterii(registerRequest.dataNasterii());

        // Setam masuratori si obiective
        utilizator.addMasuratoareGrasimeCorporala(
                masuratoriMapper.toMasuratoareGrasimeCorporala(registerRequest.masuratoareGrasimeCorporalaDto())
        );

        utilizator.addMasuratoareGreutate(
                masuratoriMapper.toMasuratoareGreutate(registerRequest.masuratoareGreutateDto())
        );

        utilizator.addMasuratoareInaltime(
                masuratoriMapper.toMasuratoareInaltime(registerRequest.masuratoareInaltimeDto())
        );

        utilizator.setIndiceMasaCorporala(registerRequest.indiceMasaCorporala());
        utilizator.setNecesarCaloricMentinere(registerRequest.necesarCaloricMentinere());
        utilizator.setNivelActivitate(registerRequest.nivelActivitate());

        utilizator.setObiectivCaloriiZi(registerRequest.obiectivCaloriiZi());
        utilizator.setObiectivGrasimiZi(registerRequest.obiectivGrasimiZi());
        utilizator.setObiectivProteineZi(registerRequest.obiectivProteineZi());
        utilizator.setObiectivCarbohidratiZi(registerRequest.obiectivCarbohidratiZi());
        utilizator.setObiectivGreutateKg(registerRequest.obiectivGreutateKg());

        return utilizator;
    }

}
