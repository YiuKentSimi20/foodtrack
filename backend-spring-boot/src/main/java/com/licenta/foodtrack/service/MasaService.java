package com.licenta.foodtrack.service;


import com.licenta.foodtrack.dto.*;
import com.licenta.foodtrack.exception.DataNotBelongingToUserException;
import com.licenta.foodtrack.mapper.CategorieMasaMapper;
import com.licenta.foodtrack.mapper.InregistrareAlimentMapper;
import com.licenta.foodtrack.mapper.MasaMapper;
import com.licenta.foodtrack.model.*;
import com.licenta.foodtrack.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

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
    private final CategorieMasaRepository categorieMasaRepository;
    private final CategorieMasaMapper categorieMasaMapper;

    public InregistrareAlimentResponse adaugaInregistrareAliment(InregistrareAlimentRequest request, UUID idUtilizatorCurent) {

        CategorieMasa categorieMasa = categorieMasaRepository.findById(request.categorieMasaId())
                .orElseThrow(() -> new IllegalStateException("Categoria mesei cu ID-ul " + request.categorieMasaId() + " nu a fost găsită."));

        if (!categorieMasa.getUtilizator().getId().equals(idUtilizatorCurent)) {
            throw new DataNotBelongingToUserException("Categoria mesei cu ID-ul " + request.categorieMasaId() + " nu aparține utilizatorului curent.");
        }

        if (!masaRepository.existsByCategorieMasaIdAndDataMeseiAndUtilizatorId(request.categorieMasaId(), request.data(), idUtilizatorCurent)) {
            Masa masa = new Masa();

            masa.setCategorieMasa(categorieMasa);
            masa.setDataMesei(request.data());
            masa.setUtilizator(utilizatorRepository.getReferenceById(idUtilizatorCurent));

            masaRepository.save(masa);
        }

        Aliment aliment = alimentRepository.findById(request.idAliment())
                .orElseThrow(() -> new IllegalStateException("Alimentul cu ID-ul " + request.idAliment() + " nu a fost găsit."));

        InregistrareAliment inregistrareAliment = inregistrareAlimentMapper.toInregistrareAliment(aliment, request.grams());
        inregistrareAliment.setMasa(masaRepository.findByCategorieMasaIdAndDataMeseiAndUtilizatorId(request.categorieMasaId(), request.data(), idUtilizatorCurent)
                .orElseThrow(() -> new IllegalStateException("Masa cu numele " + categorieMasa.getNume() + " și data " + request.data() + " pentru utilizatorul curent nu a fost găsită."))
        );

        return inregistrareAlimentMapper.toResponse(inregistrareAlimentRepository.save(inregistrareAliment));
    }

    public InregistrareAlimentResponse adaugaInregistrareManuala(InregistrareManualaRequest request,  UUID idUtilizatorCurent) {

        CategorieMasa categorieMasa = categorieMasaRepository.findById(request.categorieMasaId())
                .orElseThrow(() -> new IllegalStateException("Categoria mesei cu ID-ul " + request.categorieMasaId() + " nu a fost găsită."));

        if (categorieMasa.getUtilizator().getId() != idUtilizatorCurent) {
            throw new DataNotBelongingToUserException("Categoria mesei cu ID-ul " + request.categorieMasaId() + " nu aparține utilizatorului curent.");
        }

        if (!masaRepository.existsByCategorieMasaIdAndDataMeseiAndUtilizatorId(request.categorieMasaId(), request.data(), idUtilizatorCurent)) {

            Masa masa = new Masa();

            masa.setCategorieMasa(categorieMasa);
            masa.setDataMesei(request.data());
            masa.setUtilizator(utilizatorRepository.getReferenceById(idUtilizatorCurent));

            masaRepository.save(masa);
        }

        InregistrareAliment inregistrareAliment = inregistrareAlimentMapper.toInregistrareAliment(request);
        inregistrareAliment.setMasa(masaRepository.findByCategorieMasaIdAndDataMeseiAndUtilizatorId(request.categorieMasaId(), request.data(), idUtilizatorCurent)
                .orElseThrow(() -> new IllegalStateException("Masa cu numele " + categorieMasa.getNume() + " și data " + request.data() + " pentru utilizatorul curent nu a fost găsită."))
        );

        return inregistrareAlimentMapper.toResponse(inregistrareAlimentRepository.save(inregistrareAliment));
    }

    public List<MasaResponse> getMese(LocalDate startingDate, LocalDate endingDate, UUID idUtilizatorCurent) {


        List<Masa> mese;

        if (startingDate == null && endingDate == null) {
            mese = masaRepository.findAllByUtilizatorId(idUtilizatorCurent);
        } else if (startingDate != null && endingDate != null) {
            mese = masaRepository.findAllByUtilizatorIdAndDataMeseiBetween(idUtilizatorCurent, startingDate, endingDate);
        } else if (startingDate != null) {
            mese = masaRepository.findAllByUtilizatorIdAndDataMeseiGreaterThanEqual(idUtilizatorCurent, startingDate);
        } else {
            mese = masaRepository.findAllByUtilizatorIdAndDataMeseiLessThanEqual(idUtilizatorCurent, endingDate);
        }

        return mese.stream()
                .map(masaMapper::toResponse)
                .toList();
    }

    public List<MesePeZiResponse> getRaport(UUID idUtilizatorCurent) {

        Utilizator utilizator = utilizatorRepository.findById(idUtilizatorCurent)
                .orElseThrow(() -> new IllegalStateException("Utilizatorul cu ID-ul " + idUtilizatorCurent + " nu a fost găsit."));

        List<Masa> mese = masaRepository.findAllByUtilizatorId(idUtilizatorCurent);

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
            Double caloriiNete = utilizator.calculateTdee() - masa.stream().map(Masa::getTotalEnergyKcal).mapToDouble(Double::doubleValue).sum();


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
                            masa.stream().map(Masa::getTotalSalt).mapToDouble(Double::doubleValue).sum(),
                            caloriiNete
                            //TODO: De facut mai eficient
                    )
            );
        });

        return mesePeZiResponse;
    }

    public InregistrareAlimentResponse modificaGramajInregistrareAliment(
            ModificareGramajInregistrareAlimentRequest request,
            UUID idUtilizatorCurent) {

        InregistrareAliment inregistrareAliment = inregistrareAlimentRepository.findById(request.idInregistrare())
                .orElseThrow(() -> new IllegalStateException("Înregistrarea alimentului cu ID-ul " + request.idInregistrare() + " nu a fost găsită."));

        if (!inregistrareAliment.getMasa().getUtilizator().getId().equals(idUtilizatorCurent)) {
            throw new DataNotBelongingToUserException("Înregistrarea alimentului cu ID-ul " + request.idInregistrare() + " nu aparține utilizatorului curent.");
        }

        inregistrareAliment.setGrams(request.grams());

        return inregistrareAlimentMapper.toResponse(inregistrareAlimentRepository.save(inregistrareAliment));
    }

    public InregistrareAlimentResponse modificaInregistrareManuala(
            ModificareInregistrareManualaRequest request,
            UUID idUtilizatorCurent) {


        InregistrareAliment inregistrareAliment = inregistrareAlimentRepository.findByIdAndTipInregistrare(request.id(), TipInregistrare.MANUAL)
                .orElseThrow(() -> new IllegalStateException("Înregistrarea manuala alimentului cu ID-ul " + request.id() + " nu a fost găsită."));

        if (!inregistrareAliment.getMasa().getUtilizator().getId().equals(idUtilizatorCurent)) {
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

    public void stergeInregistrareAliment(Long id, UUID idUtilizatorCurent) {

        InregistrareAliment inregistrareAliment = inregistrareAlimentRepository.findById(id)
                .orElseThrow(() -> new IllegalStateException("Înregistrarea alimentului cu ID-ul " + id + " nu a fost găsită."));

        if (!inregistrareAliment.getMasa().getUtilizator().getId().equals(idUtilizatorCurent)) {
            throw new DataNotBelongingToUserException("Înregistrarea alimentului cu ID-ul " + id + " nu aparține utilizatorului curent.");
        }

        inregistrareAlimentRepository.deleteById(id);
    }

    public List<CategorieMasaDto> getCategoriiMese(UUID idUtilizatorCurent) {

        return categorieMasaRepository.findAllByUtilizatorIdOrderByNumarOrdine(idUtilizatorCurent).stream()
                .map(categorieMasaMapper::toDto)
                .toList();
    }

    public List<CategorieMasaDto> updateCategoriiMese(UpdateCategoriiMeseRequest request, UUID idUtilizatorCurent) {

        Set<Integer> numereOrdine = request.categoriiMese().stream()
                .map(CategorieMasaDto::numarOrdine)
                .collect(Collectors.toSet());

        Set<Long> idCategorii = request.categoriiMese().stream()
                .map(CategorieMasaDto::id)
                .collect(Collectors.toSet());

        if (numereOrdine.size() != request.categoriiMese().size()) {
            throw new IllegalArgumentException("numar_ordine trebuie sa fie distinct pentru fiecare categorie.");
        }

        if(idCategorii.size() != request.categoriiMese().size()) {
            throw new IllegalArgumentException("id trebuie sa fie distinct pentru fiecare categorie. O categorie se poate modifica doar odata pe cerere");
        }

        List<CategorieMasa> categoriiMese = categorieMasaRepository.findAllByUtilizatorIdOrderByNumarOrdine(idUtilizatorCurent);

        request.categoriiMese()
                .forEach(categorieMasaDto -> {
                    CategorieMasa categorieMasa = categoriiMese.stream()
                            .filter(cm -> cm.getId().equals(categorieMasaDto.id()))
                            .findFirst()
                            .orElseThrow(() -> new IllegalStateException("Categoria mesei cu ID-ul " + categorieMasaDto.id() + " nu a fost găsită."));

                    if (!categorieMasa.getUtilizator().getId().equals(idUtilizatorCurent)) {
                        throw new DataNotBelongingToUserException("Categoria mesei cu ID-ul " + categorieMasaDto.id() + " nu aparține utilizatorului curent.");
                    }

                    categorieMasa.setNume(categorieMasaDto.nume());
                    categorieMasa.setNumarOrdine(categorieMasaDto.numarOrdine());
                });

        return categorieMasaRepository.saveAll(categoriiMese).stream()
                .map(categorieMasaMapper::toDto)
                .toList();
    }

}
