package com.licenta.foodtrack.service;


import com.licenta.foodtrack.dto.*;
import com.licenta.foodtrack.exception.DataNotBelongingToUserException;
import com.licenta.foodtrack.mapper.InregistrareAlimentMapper;
import com.licenta.foodtrack.mapper.MasaMapper;
import com.licenta.foodtrack.model.*;
import com.licenta.foodtrack.repository.AlimentRepository;
import com.licenta.foodtrack.repository.InregistrareAlimentRepository;
import com.licenta.foodtrack.repository.MasaRepository;
import com.licenta.foodtrack.repository.UtilizatorRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestBody;

import java.time.LocalDate;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class MasaService {

    private final MasaRepository masaRepository;
    private final AlimentRepository alimentRepository;
    private final InregistrareAlimentRepository inregistrareAlimentRepository;
    private final UtilizatorRepository utilizatorRepository;
    private final InregistrareAlimentMapper inregistrareAlimentMapper;
    private final MasaMapper masaMapper;

    public InregistrareAlimentResponse adaugaInregistrareAliment(@RequestBody InregistrareAlimentRequest request) {

        Utilizator utilizator = getCurrentUser();

        if (!masaRepository.existsByNumeAndDataMeseiAndUtilizatorId(request.numeMasa(), request.data(), utilizator.getId())) {
            Masa masa = new Masa();
            masa.setNume(request.numeMasa());
            masa.setDataMesei(request.data());
            masa.setUtilizator(utilizator);

            masaRepository.save(masa);
            System.out.println("Masa creată: " + masa.getNume() + " la data " + masa.getDataMesei());
        }

        Aliment aliment = alimentRepository.findById(request.idAliment())
                .orElseThrow(() -> new IllegalStateException("Alimentul cu ID-ul " + request.idAliment() + " nu a fost găsit."));

        InregistrareAliment inregistrareAliment = inregistrareAlimentMapper.toInregistrareAliment(aliment, request.grams());
        inregistrareAliment.setMasa(masaRepository.findByNumeAndDataMeseiAndUtilizatorId(request.numeMasa(), request.data(), utilizator.getId())
                .orElseThrow(() -> new IllegalStateException("Masa cu numele " + request.numeMasa() + " și data " + request.data() + " pentru utilizatorul curent nu a fost găsită."))
        );

        return inregistrareAlimentMapper.toResponse(inregistrareAlimentRepository.save(inregistrareAliment));
    }

    public InregistrareAlimentResponse adaugaInregistrareManuala(InregistrareManualaRequest request) {

        Utilizator utilizator = getCurrentUser();

        if (!masaRepository.existsByNumeAndDataMeseiAndUtilizatorId(request.numeMasa(), request.data(), utilizator.getId())) {
            Masa masa = new Masa();
            masa.setNume(request.numeMasa());
            masa.setDataMesei(request.data());
            masa.setUtilizator(utilizator);

            masaRepository.save(masa);
            System.out.println("Masa creată: " + masa.getNume() + " la data " + masa.getDataMesei());
        }

        InregistrareAliment inregistrareAliment = inregistrareAlimentMapper.toInregistrareAliment(request);
        inregistrareAliment.setMasa(masaRepository.findByNumeAndDataMeseiAndUtilizatorId(request.numeMasa(), request.data(), utilizator.getId())
                .orElseThrow(() -> new IllegalStateException("Masa cu numele " + request.numeMasa() + " și data " + request.data() + " pentru utilizatorul curent nu a fost găsită."))
        );

        return inregistrareAlimentMapper.toResponse(inregistrareAlimentRepository.save(inregistrareAliment));
    }

    public List<MasaResponse> getMese(LocalDate startingDate, LocalDate endingDate) {

        UUID userId = getCurrentUser().getId();

        List<Masa> mese;

        if (startingDate == null && endingDate == null) {
            mese = masaRepository.findAllByUtilizatorId(userId);
        } else if (startingDate != null && endingDate != null) {
            mese = masaRepository.findAllByUtilizatorIdAndDataMeseiBetween(userId, startingDate, endingDate);
        } else if (startingDate != null) {
            mese = masaRepository.findAllByUtilizatorIdAndDataMeseiGreaterThanEqual(userId, startingDate);
        } else {
            mese = masaRepository.findAllByUtilizatorIdAndDataMeseiLessThanEqual(userId, endingDate);
        }

        return mese.stream()
                .map(masaMapper::toResponse)
                .toList();
    }

    public List<MesePeZiResponse> getRaport() {

        Utilizator utilizator = getCurrentUser();

        List<Masa> mese = masaRepository.findAllByUtilizatorId(utilizator.getId());

        Map<LocalDate, List<Masa>> mesePeZile = mese.stream()
                .sorted(Comparator.comparing(Masa::getDataMesei))
                .collect(Collectors.groupingBy(
                        Masa::getDataMesei,
                        TreeMap::new,
                        Collectors.toList()
                ));

        List<MesePeZiResponse> mesePeZiResponse = new ArrayList<>();

        mesePeZile.forEach((date, masa) -> {
            Obiectiv obiectiv = utilizator.getObiectivFor(date).orElseThrow(() -> new IllegalStateException("Nu exista obiective setate"));
            mesePeZiResponse.add(new MesePeZiResponse(
                            date,
                            masa.stream()
                                    .map(masaMapper::toResponse)
                                    .toList(),
                            obiectiv.getCalories(),
                            obiectiv.getProtein(),
                            obiectiv.getCarbohydrates(),
                            obiectiv.getFat(),
                            masa.stream().map(Masa::getTotalEnergyKcal).mapToDouble(Double::doubleValue).sum(),
                            masa.stream().map(Masa::getTotalEnergyKj).mapToDouble(Double::doubleValue).sum(),
                            masa.stream().map(Masa::getTotalFat).mapToDouble(Double::doubleValue).sum(),
                            masa.stream().map(Masa::getFatCaloriesPercent).mapToDouble(Double::doubleValue).average().orElse(0.0),
                            masa.stream().map(Masa::getTotalSaturatedFat).mapToDouble(Double::doubleValue).sum(),
                            masa.stream().map(Masa::getTotalCarbohydrates).mapToDouble(Double::doubleValue).sum(),
                            masa.stream().map(Masa::getCarbohydratesCaloriesPercent).mapToDouble(Double::doubleValue).average().orElse(0.0),
                            masa.stream().map(Masa::getTotalSugars).mapToDouble(Double::doubleValue).sum(),
                            masa.stream().map(Masa::getTotalFiber).mapToDouble(Double::doubleValue).sum(),
                            masa.stream().map(Masa::getTotalProtein).mapToDouble(Double::doubleValue).sum(),
                            masa.stream().map(Masa::getProteinCaloriesPercent).mapToDouble(Double::doubleValue).average().orElse(0.0),
                            masa.stream().map(Masa::getTotalSalt).mapToDouble(Double::doubleValue).sum()
                            //TODO: De facut mai eficient
                    )
            );
        });

        return mesePeZiResponse;
    }

    public InregistrareAlimentResponse modificaGramajInregistrareAliment(ModificareGramajInregistrareAlimentRequest request) {

        Utilizator utilizator = getCurrentUser();

        InregistrareAliment inregistrareAliment = inregistrareAlimentRepository.findById(request.idInregistrare())
                .orElseThrow(() -> new IllegalStateException("Înregistrarea alimentului cu ID-ul " + request.idInregistrare() + " nu a fost găsită."));

        if (!inregistrareAliment.getMasa().getUtilizator().getId().equals(utilizator.getId())) {
            throw new DataNotBelongingToUserException("Înregistrarea alimentului cu ID-ul " + request.idInregistrare() + " nu aparține utilizatorului curent.");
        }

        inregistrareAliment.setGrams(request.grams());

        return inregistrareAlimentMapper.toResponse(inregistrareAlimentRepository.save(inregistrareAliment));
    }

    public InregistrareAlimentResponse modificaInregistrareManuala(ModificareInregistrareManualaRequest request) {

        Utilizator utilizator = getCurrentUser();

        InregistrareAliment inregistrareAliment = inregistrareAlimentRepository.findByIdAndTipInregistrare(request.id(), TipInregistrare.MANUAL)
                .orElseThrow(() -> new IllegalStateException("Înregistrarea manuala alimentului cu ID-ul " + request.id() + " nu a fost găsită."));

        if (!inregistrareAliment.getMasa().getUtilizator().getId().equals(utilizator.getId())) {
            throw new DataNotBelongingToUserException("Înregistrarea alimentului cu ID-ul " + request.id() + " nu aparține utilizatorului curent.");
        }

        if (request.grams() != null) inregistrareAliment.setGrams(request.grams());
        if (request.calories() != null) inregistrareAliment.setEnergyKcal100g(request.calories());
        if (request.fat() != null) inregistrareAliment.setFat100g(request.fat());
        if (request.carbohydrates() != null) inregistrareAliment.setCarbohydrates100g(request.carbohydrates());
        if (request.fiber() != null) inregistrareAliment.setFiber100g(request.fiber());
        if (request.protein() != null) inregistrareAliment.setProtein100g(request.protein());

        return inregistrareAlimentMapper.toResponse(inregistrareAlimentRepository.save(inregistrareAliment));
    }

    public void stergeInregistrareAliment(Long id) {

        Utilizator utilizator = getCurrentUser();

        InregistrareAliment inregistrareAliment = inregistrareAlimentRepository.findById(id)
                .orElseThrow(() -> new IllegalStateException("Înregistrarea alimentului cu ID-ul " + id + " nu a fost găsită."));

        if (!inregistrareAliment.getMasa().getUtilizator().getId().equals(utilizator.getId())) {
            throw new DataNotBelongingToUserException("Înregistrarea alimentului cu ID-ul " + id + " nu aparține utilizatorului curent.");
        }

        inregistrareAlimentRepository.deleteById(id);
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
