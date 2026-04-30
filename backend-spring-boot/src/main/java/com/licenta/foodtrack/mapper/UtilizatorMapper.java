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
    public final ObiectivMapper obiectivMapper;

    public Utilizator toUtilizator(RegisterRequest registerRequest) {
        Utilizator utilizator = new Utilizator();

        utilizator.setUsername(registerRequest.username());
        utilizator.setEmail(registerRequest.email());
        utilizator.setGen(registerRequest.gen());
        utilizator.setDataNasterii(registerRequest.dataNasterii());
        utilizator.setNivelActivitate(registerRequest.nivelActivitate());

        // Setam masuratori si obiective
//        utilizator.addObiectiv(
//                obiectivMapper.toObiectiv(registerRequest.obiectivDto())
//        );
//
//        utilizator.addMasuratoareGrasimeCorporala(
//                masuratoriMapper.toMasuratoareGrasimeCorporala(registerRequest.masuratoareGrasimeCorporalaDto())
//        );
//
//        utilizator.addMasuratoareGreutate(
//                masuratoriMapper.toMasuratoareGreutate(registerRequest.masuratoareGreutateDto())
//        );
//
//        utilizator.addMasuratoareInaltime(
//                masuratoriMapper.toMasuratoareInaltime(registerRequest.masuratoareInaltimeDto())
//        );

//        utilizator.setIndiceMasaCorporala(registerRequest.indiceMasaCorporala());
//        utilizator.setNecesarCaloricMentinere(registerRequest.necesarCaloricMentinere());
//        utilizator.setNivelActivitate(registerRequest.nivelActivitate());

        return utilizator;
    }

}
