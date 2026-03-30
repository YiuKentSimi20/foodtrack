package com.licenta.foodtrack.mapper;

import com.licenta.foodtrack.dto.MasuratoareGrasimeCorporalaDto;
import com.licenta.foodtrack.dto.MasuratoareGreutateDto;
import com.licenta.foodtrack.dto.MasuratoareInaltimeDto;
import com.licenta.foodtrack.model.MasuratoareGrasimeCorporala;
import com.licenta.foodtrack.model.MasuratoareGreutate;
import com.licenta.foodtrack.model.MasuratoareInaltime;
import org.springframework.stereotype.Component;

import java.time.LocalDate;

@Component
public class MasuratoriMapper {

    public MasuratoareGrasimeCorporala toMasuratoareGrasimeCorporala(MasuratoareGrasimeCorporalaDto dto) {

        MasuratoareGrasimeCorporala masuratoare = new MasuratoareGrasimeCorporala();

        masuratoare.setGrasimeCorporalaProcent(dto.grasimeCorporalaProcent());
        masuratoare.setDate(LocalDate.parse(dto.dataMasuratoare()));

        return masuratoare;
    }

    public MasuratoareInaltime toMasuratoareInaltime(MasuratoareInaltimeDto dto) {

        MasuratoareInaltime masuratoare = new MasuratoareInaltime();

        masuratoare.setInaltimeCm(dto.inaltimeCm());
        masuratoare.setDate(LocalDate.parse(dto.dataMasuratoare()));

        return masuratoare;
    }

    public MasuratoareGreutate toMasuratoareGreutate(MasuratoareGreutateDto dto) {

        MasuratoareGreutate masuratoare = new MasuratoareGreutate();

        masuratoare.setGreutateKg(dto.greutatekg());
        masuratoare.setDate(LocalDate.parse(dto.dataMasuratoare()));

        return masuratoare;
    }

}
