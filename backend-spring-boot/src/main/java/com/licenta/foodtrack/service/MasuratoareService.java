package com.licenta.foodtrack.service;

import com.licenta.foodtrack.dto.*;
import com.licenta.foodtrack.mapper.MasuratoriMapper;
import com.licenta.foodtrack.mapper.ObiectivMapper;
import com.licenta.foodtrack.model.*;
import com.licenta.foodtrack.repository.*;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import java.util.List;

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

    public List<MasuratoareGreutateDto> getMasuratoriGreutate() {

        Utilizator utilizator = getCurrentUser();

        return masuratoareGreutateRepository.findByUtilizatorId(utilizator.getId())
                .stream()
                .map(m -> new MasuratoareGreutateDto(m.getGreutateKg(), m.getDate()))
                .toList();
    }

    public List<MasuratoareInaltimeDto> getMasuratoriInaltime() {

        Utilizator utilizator = getCurrentUser();

        return masuratoareInaltimeRepository.findByUtilizatorId(utilizator.getId())
                .stream()
                .map(m -> new MasuratoareInaltimeDto(m.getInaltimeCm(), m.getDate()))
                .toList();
    }

    public List<MasuratoareGrasimeCorporalaDto> getMasuratoriGrasimeCorporala() {

        Utilizator utilizator = getCurrentUser();

        return masuratoareGrasimeCorporalaRepository.findByUtilizatorId(utilizator.getId())
                .stream()
                .map(m -> new MasuratoareGrasimeCorporalaDto(m.getGrasimeCorporalaProcent(), m.getDate()))
                .toList();
    }

    public List<ObiectivDto> getObiective() {

        Utilizator utilizator = getCurrentUser();

        return obiectivRepository.findByUtilizatorId(utilizator.getId())
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

    public MasuratoareGreutateResponse adaugaMasuratoareGreutate(MasuratoareGreutateDto masuratoareGreutateDto) {

        Utilizator utilizator = getCurrentUser();

        MasuratoareGreutate masuratoareGreutate = masuratoareGreutateRepository.findByUtilizatorIdAndDate(utilizator.getId(), masuratoareGreutateDto.dataMasuratoare())
                .orElse(masuratoriMapper.toMasuratoareGreutate(masuratoareGreutateDto));

        masuratoareGreutate.setGreutateKg(masuratoareGreutateDto.greutatekg());
        masuratoareGreutate.setUtilizator(utilizator);

        return masuratoriMapper.toMasuratoareGreutateResponse(masuratoareGreutateRepository.save(masuratoareGreutate));

    }

    public MasuratoareInaltimeResponse adaugaMasuratoareInaltime(MasuratoareInaltimeDto masuratoareInaltimeDto) {

        Utilizator utilizator = getCurrentUser();

        MasuratoareInaltime masuratoareInaltime = masuratoareInaltimeRepository.findByUtilizatorIdAndDate(utilizator.getId(), masuratoareInaltimeDto.dataMasuratoare())
                .orElse(masuratoriMapper.toMasuratoareInaltime(masuratoareInaltimeDto));


        masuratoareInaltime.setInaltimeCm(masuratoareInaltimeDto.inaltimeCm());
        masuratoareInaltime.setUtilizator(utilizator);

        return masuratoriMapper.toMasuratoareInaltimeResponse(masuratoareInaltimeRepository.save(masuratoareInaltime));
    }

    public MasuratoareGrasimeCorporalaResponse adaugaMasuratoareGrasimeCorporala(MasuratoareGrasimeCorporalaDto masuratoareGrasimeCorporalaDto) {

        Utilizator utilizator = getCurrentUser();

        MasuratoareGrasimeCorporala masuratoareGrasimeCorporala = masuratoareGrasimeCorporalaRepository.findByUtilizatorIdAndDate(utilizator.getId(), masuratoareGrasimeCorporalaDto.dataMasuratoare())
                .orElse(masuratoriMapper.toMasuratoareGrasimeCorporala(masuratoareGrasimeCorporalaDto));

        masuratoareGrasimeCorporala.setGrasimeCorporalaProcent(masuratoareGrasimeCorporalaDto.grasimeCorporalaProcent());
        masuratoareGrasimeCorporala.setUtilizator(utilizator);

        return masuratoriMapper.toMasuratoareGrasimeCorporalaResponse(masuratoareGrasimeCorporalaRepository.save(masuratoareGrasimeCorporala));
    }

    public ObiectivDto adaugaObiectiv(@Valid ObiectivDto obiectivDto) {

        Utilizator utilizator = getCurrentUser();

        Obiectiv obiectiv = obiectivRepository.findByUtilizatorIdAndDataStart(utilizator.getId(), obiectivDto.data())
                .orElse(obiectivMapper.toObiectiv(obiectivDto));

        obiectiv.setCalories(obiectivDto.obiectivCaloriiZi());
        obiectiv.setProtein(obiectivDto.obiectivProteineZi());
        obiectiv.setCarbohydrates(obiectivDto.obiectivCarbohidratiZi());
        obiectiv.setFat(obiectivDto.obiectivGrasimiZi());
        obiectiv.setUtilizator(utilizator);


        return obiectivMapper.toObiectivDto(obiectivRepository.save(obiectiv));
    }

    public Utilizator getCurrentUser() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || !auth.isAuthenticated()) {
            throw new IllegalStateException("Utilizator neautentificat");
        }

        Object principal = auth.getPrincipal();
        if (!(principal instanceof Utilizator u)) {
            throw new IllegalStateException("Principal invalid: " + principal);
        }

        return utilizatorRepository.findById(u.getId())
                .orElseThrow(() -> new IllegalStateException("Utilizatorul cu ID-ul " + u.getId() + " nu a fost găsit."));
    }
}
