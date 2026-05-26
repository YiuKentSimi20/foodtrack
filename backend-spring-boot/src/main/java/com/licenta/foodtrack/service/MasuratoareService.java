package com.licenta.foodtrack.service;

import com.licenta.foodtrack.dto.*;
import com.licenta.foodtrack.exception.ObiectivInvalidNutrientsException;
import com.licenta.foodtrack.mapper.MasuratoriMapper;
import com.licenta.foodtrack.mapper.ObiectivMapper;
import com.licenta.foodtrack.model.*;
import com.licenta.foodtrack.repository.*;
import com.licenta.foodtrack.util.MacroProcentsCalculator;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
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

    public List<ObiectivResponse> getObiective(UUID idUtilizatorCurent) {

        Utilizator utilizator = utilizatorRepository.findById(idUtilizatorCurent)
                .orElseThrow(() -> new RuntimeException("Utilizatorul nu a fost găsit"));


        return obiectivRepository.findByUtilizatorId(idUtilizatorCurent)
                .stream()
                .map(o -> {
                    MacroProcentsCalculator.MacroPercents macroPercents = MacroProcentsCalculator.calcPercentsSumOne(
                            o.getFat(),
                            o.getCarbohydrates(),
                            o.getProtein()
                    );

                    Double lastMasuratoareGreutate = utilizator.getLastMasuratoareGreutate().orElseThrow(() -> new RuntimeException("Utilizatorul nu are măsurătoare de greutate"));

                    Double proteinKgCorp = o.getProtein() / lastMasuratoareGreutate;
                    Double carbsKgCorp = o.getCarbohydrates() / lastMasuratoareGreutate;
                    Double fatKgCorp = o.getFat() / lastMasuratoareGreutate;

                    return new ObiectivResponse(
                            o.getDataStart(),
                            o.getCalories(),
                            o.getProtein(),
                            macroPercents.proteinPercent(),
                            o.getCarbohydrates(),
                            macroPercents.carbsPercent(),
                            o.getFat(),
                            macroPercents.fatPercent(),
                            proteinKgCorp,
                            carbsKgCorp,
                            fatKgCorp,
                            o.calculateNetCalories(o.getDataStart()),
                            o.calculateWeightCaloriesPerWeek(o.getDataStart())
                    );
                        }
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

    public ObiectivResponse getObiectivPreview(ObiectivDto obiectivDto, UUID id) {

        Utilizator utilizator = utilizatorRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Utilizatorul nu a fost găsit"));

        Obiectiv obiectiv = obiectivMapper.toObiectiv(obiectivDto);
        obiectiv.setUtilizator(utilizator);

        MacroProcentsCalculator.MacroPercents macroPercents = MacroProcentsCalculator.calcPercentsSumOne(
                obiectiv.getFat(),
                obiectiv.getCarbohydrates(),
                obiectiv.getProtein()
        );

        Double lastMasuratoareGreutate = utilizator.getLastMasuratoareGreutate().orElseThrow(() -> new RuntimeException("Utilizatorul nu are măsurătoare de greutate"));

        Double proteinKgCorp = obiectiv.getProtein() / lastMasuratoareGreutate;
        Double carbsKgCorp = obiectiv.getCarbohydrates() / lastMasuratoareGreutate;
        Double fatKgCorp = obiectiv.getFat() / lastMasuratoareGreutate;

        return new ObiectivResponse(
                obiectiv.getDataStart(),
                obiectiv.getCalories(),
                obiectiv.getProtein(),
                macroPercents.proteinPercent(),
                obiectiv.getCarbohydrates(),
                macroPercents.carbsPercent(),
                obiectiv.getFat(),
                macroPercents.fatPercent(),
                proteinKgCorp,
                carbsKgCorp,
                fatKgCorp,
                obiectiv.calculateNetCalories(LocalDate.now()),
                obiectiv.calculateWeightCaloriesPerWeek(LocalDate.now())
        );
    }

    public ObiectivCalculatResponse calculeazaObiectiv(Double tdeeCaloriesPercentage, UUID utilizatorId) {

        Utilizator utilizator = utilizatorRepository.findById(utilizatorId)
                .orElseThrow(() -> new RuntimeException("Utilizatorul nu a fost găsit"));

        Double tdee = utilizator.calculateTdee(LocalDate.now());
        Double calories = tdee * tdeeCaloriesPercentage;
        Double proteinPercent = 0.2;
        Double carbsPercent = 0.5;
        Double fatPercent = 0.3;
        Double protein = calories * proteinPercent / 4;
        Double carbohydrates = calories * carbsPercent / 4;
        Double fat = calories * fatPercent / 9;

        return new ObiectivCalculatResponse(protein, carbohydrates, fat);
    }
}
