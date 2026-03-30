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
        utilizator.setPassword(registerRequest.password());
        utilizator.setEmail(registerRequest.email());
        utilizator.setGen(GenUtilizator.valueOf(registerRequest.gen().toUpperCase()));
        utilizator.setDataNasterii(LocalDate.parse(registerRequest.dataNasterii()));

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
        utilizator.setNivelActivitate(NivelActivitate.valueOf(registerRequest.nivelActivitate().toUpperCase()));

        utilizator.setObiectivCaloriiZi(registerRequest.obiectivCaloriiZi());
        utilizator.setObiectivGrasimiZi(registerRequest.obiectivGrasimiZi());
        utilizator.setObiectivProteineZi(registerRequest.obiectivProteineZi());
        utilizator.setObiectivCarbohidratiZi(registerRequest.obiectivCarbohidratiZi());
        utilizator.setObiectivGreutateKg(registerRequest.obiectivGreutateKg());

        return utilizator;
    }

}
