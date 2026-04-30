package com.licenta.foodtrack.service;

import com.licenta.foodtrack.dto.*;
import com.licenta.foodtrack.exception.ObiectivInvalidNutrientsException;
import com.licenta.foodtrack.mapper.MasuratoriMapper;
import com.licenta.foodtrack.mapper.ObiectivMapper;
import com.licenta.foodtrack.model.MasuratoareGrasimeCorporala;
import com.licenta.foodtrack.model.MasuratoareGreutate;
import com.licenta.foodtrack.model.MasuratoareInaltime;
import com.licenta.foodtrack.model.Obiectiv;
import com.licenta.foodtrack.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class MasuratoareService {

    private final MasuratoareGrasimeCorporalaRepository masuratoareGrasimeCorporalaRepository;
    private final MasuratoareGreutateRepository masuratoareGreutateRepository;
    private final MasuratoareInaltimeRepository masuratoareInaltimeRepository;
    private final ObiectivRepository obiectivRepository;
    private final UtilizatorRepository utilizatorRepository;
    private final MasuratoriMapper masuratoriMapper;
    private final ObiectivMapper obiectivMapper;

    public List<MasuratoareGreutateDto> getMasuratoriGreutate(UUID idUtilizatorCurent) {

        return masuratoareGreutateRepository.findByUtilizatorId(idUtilizatorCurent)
                .stream()
                .map(m -> new MasuratoareGreutateDto(m.getGreutateKg(), m.getDate()))
                .toList();
    }

    public List<MasuratoareInaltimeDto> getMasuratoriInaltime(UUID idUtilizatorCurent) {

        return masuratoareInaltimeRepository.findByUtilizatorId(idUtilizatorCurent)
                .stream()
                .map(m -> new MasuratoareInaltimeDto(m.getInaltimeCm(), m.getDate()))
                .toList();
    }

    public List<MasuratoareGrasimeCorporalaDto> getMasuratoriGrasimeCorporala(UUID idUtilizatorCurent) {

        return masuratoareGrasimeCorporalaRepository.findByUtilizatorId(idUtilizatorCurent)
                .stream()
                .map(m -> new MasuratoareGrasimeCorporalaDto(m.getGrasimeCorporalaProcent(), m.getDate()))
                .toList();
    }

    public List<ObiectivDto> getObiective(UUID idUtilizatorCurent) {

        return obiectivRepository.findByUtilizatorId(idUtilizatorCurent)
                .stream()
                .map(o -> new ObiectivDto(
                        o.getDataStart(),
                        o.getCalories(),
                        o.getProtein(),
                        o.getCarbohydrates(),
                        o.getFat())
                )
                .toList();
    }

    public MasuratoareGreutateResponse adaugaMasuratoareGreutate(
            MasuratoareGreutateDto masuratoareGreutateDto,
            UUID idUtilizatorCurent) {

        MasuratoareGreutate masuratoareGreutate = masuratoareGreutateRepository
                .findByUtilizatorIdAndDate(idUtilizatorCurent, masuratoareGreutateDto.dataMasuratoare())
                .orElse(masuratoriMapper.toMasuratoareGreutate(masuratoareGreutateDto));

        masuratoareGreutate.setGreutateKg(masuratoareGreutateDto.greutatekg());
        masuratoareGreutate.setUtilizator(utilizatorRepository.getReferenceById(idUtilizatorCurent));

        return masuratoriMapper.toMasuratoareGreutateResponse(masuratoareGreutateRepository.save(masuratoareGreutate));

    }

    public MasuratoareInaltimeResponse adaugaMasuratoareInaltime(
            MasuratoareInaltimeDto masuratoareInaltimeDto,
            UUID idUtilizatorCurent) {

        MasuratoareInaltime masuratoareInaltime = masuratoareInaltimeRepository.
                findByUtilizatorIdAndDate(idUtilizatorCurent, masuratoareInaltimeDto.dataMasuratoare())
                .orElse(masuratoriMapper.toMasuratoareInaltime(masuratoareInaltimeDto));


        masuratoareInaltime.setInaltimeCm(masuratoareInaltimeDto.inaltimeCm());
        masuratoareInaltime.setUtilizator(utilizatorRepository.getReferenceById(idUtilizatorCurent));

        return masuratoriMapper.toMasuratoareInaltimeResponse(masuratoareInaltimeRepository.save(masuratoareInaltime));
    }

    public MasuratoareGrasimeCorporalaResponse adaugaMasuratoareGrasimeCorporala(
            MasuratoareGrasimeCorporalaDto masuratoareGrasimeCorporalaDto,
            UUID idUtilizatorCurent) {

        MasuratoareGrasimeCorporala masuratoareGrasimeCorporala = masuratoareGrasimeCorporalaRepository.
                findByUtilizatorIdAndDate(idUtilizatorCurent, masuratoareGrasimeCorporalaDto.dataMasuratoare())
                .orElse(masuratoriMapper.toMasuratoareGrasimeCorporala(masuratoareGrasimeCorporalaDto));

        masuratoareGrasimeCorporala.setGrasimeCorporalaProcent(masuratoareGrasimeCorporalaDto.grasimeCorporalaProcent());
        masuratoareGrasimeCorporala.setUtilizator(utilizatorRepository.getReferenceById(idUtilizatorCurent));

        return masuratoriMapper.toMasuratoareGrasimeCorporalaResponse(masuratoareGrasimeCorporalaRepository
                .save(masuratoareGrasimeCorporala));
    }

    public ObiectivDto adaugaObiectiv(ObiectivDto obiectivDto, UUID idUtilizatorCurent) {

        Obiectiv obiectiv = obiectivRepository.
                findByUtilizatorIdAndDataStart(idUtilizatorCurent, obiectivDto.data())
                .orElse(obiectivMapper.toObiectiv(obiectivDto));

        obiectiv.setCalories(obiectivDto.obiectivCaloriiZi());
        obiectiv.setProtein(obiectivDto.obiectivProteineZi());
        obiectiv.setCarbohydrates(obiectivDto.obiectivCarbohidratiZi());
        obiectiv.setFat(obiectivDto.obiectivGrasimiZi());
        obiectiv.setUtilizator(utilizatorRepository.getReferenceById(idUtilizatorCurent));

        if(!obiectiv.nutrientsAreValid()) {
            throw new ObiectivInvalidNutrientsException("Nutrients are invalid, nutrients calories must be equal to total calories.");
        }

        return obiectivMapper.toObiectivDto(obiectivRepository.save(obiectiv));
    }
}
