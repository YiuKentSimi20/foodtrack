package com.licenta.foodtrack.service;

import com.licenta.foodtrack.dto.AlimentDto;
import com.licenta.foodtrack.dto.CreateAlimentRequest;
import com.licenta.foodtrack.dto.OffBarcodeResponse;
import com.licenta.foodtrack.exception.BarcodeNotFoundException;
import com.licenta.foodtrack.exception.DataNotBelongingToUserException;
import com.licenta.foodtrack.mapper.AlimentMapper;
import com.licenta.foodtrack.model.Aliment;
import com.licenta.foodtrack.model.NutritionScore;
import com.licenta.foodtrack.repository.AlimentRepository;
import com.licenta.foodtrack.repository.UtilizatorRepository;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class AlimentService {

    private final OpenFoodFactsService openFoodFactsService;
    private final AlimentMapper alimentMapper;
    private final AlimentRepository alimentRepository;
    private final UtilizatorRepository utilizatorRepository;

    public List<Aliment> searchByNameMock(String name, UUID idUtilizatorCurent) {

        List<Aliment> alimente = alimentRepository.findByProductNameContainingIgnoreCaseAndIsValidatedTrue(name);

        alimente.addAll(alimentRepository.findByProductNameContainingIgnoreCaseAndCreatedByUserIdAndIsValidatedFalse(name, idUtilizatorCurent));

        openFoodFactsService.searchProductsMock(name)
                .stream()
                .filter(offProduct -> offProduct.nutriments() != null)
                .map(alimentMapper::toAliment)
                .filter(aliment -> !alimente.contains(aliment))
                .filter(aliment -> !alimentRepository.existsByCode(aliment.getCode()))
                .map(alimentRepository::save)
                .forEach(alimente::add);

        return alimente;
    }

    public List<Aliment> searchByName(String name, UUID idUtilizatorCurent) {

        List<Aliment> alimente = alimentRepository.findByProductNameContainingIgnoreCaseAndIsValidatedTrue(name);

        alimente.addAll(alimentRepository.findByProductNameContainingIgnoreCaseAndCreatedByUserIdAndIsValidatedFalse(name, idUtilizatorCurent));

        openFoodFactsService.searchProductsByName(name)
                .stream()
                .filter(offProduct -> offProduct.nutriments() != null)
                .map(alimentMapper::toAliment)
                .filter(aliment -> !alimente.contains(aliment))
                .filter(aliment -> !alimentRepository.existsByCode(aliment.getCode()))
                .map(alimentRepository::save)
                .forEach(alimente::add);

        return alimente;
    }

    public Aliment searchByBarcode(String barcode) {
        // Se cauta in baza de date. Daca nu se gaseste, se apeleaza API-ul OFF
        // Daca API-ul returneaza un produs valid, se salveaza in baza de date si se returneaza

        Optional<Aliment> aliment = alimentRepository.findByCode(barcode)
                .or(() -> openFoodFactsService.getProductByBarcode(barcode)
                        .map(OffBarcodeResponse::product)
                        .map(alimentMapper::toAliment)
                        .filter(a -> a.getCode() != null && !a.getCode().isBlank())
                        .filter(a -> !alimentRepository.existsByCode(a.getCode()))
                        .map(alimentRepository::save));

        return aliment.orElseThrow(() -> new BarcodeNotFoundException(barcode));
    }

    public AlimentDto addAliment(CreateAlimentRequest request, UUID idUtilizatorCurent) {

        Aliment aliment = alimentMapper.toAliment(request);

        aliment.setIsValidated(false);
        aliment.setCreatedByUserId(idUtilizatorCurent);

        return alimentMapper.toAlimentDto(alimentRepository.save(aliment));

    }

    public AlimentDto updateAliment(@Valid CreateAlimentRequest request, Long id, UUID idUtilizatorCurent) {

        Aliment aliment = alimentRepository.findById(id)
                .orElseThrow(() -> new IllegalStateException("Alimentul cu id-ul " + id + " nu a fost găsit"));

        if(aliment.getCreatedByUserId() == null || !aliment.getCreatedByUserId().equals(idUtilizatorCurent)) {
            throw new DataNotBelongingToUserException("Alimentul cu ID-ul " + id + " nu apartine utilizatorului curent.");
        }

        if (request.productName() != null) { aliment.setProductName(request.productName()); }
        if (request.brands() != null) { aliment.setBrands(request.brands()); }
        if (request.code() != null) { aliment.setCode(request.code()); }
        if (request.energyKcal100g() != null) { aliment.setEnergyKcal100g(request.energyKcal100g()); }
        if (request.fat100g() != null) { aliment.setFat100g(request.fat100g()); }
        if (request.saturatedFat100g() != null) { aliment.setSaturatedFat100g(request.saturatedFat100g()); }
        if (request.carbohydrates100g() != null) { aliment.setCarbohydrates100g(request.carbohydrates100g()); }
        if (request.sugars100g() != null) { aliment.setSugars100g(request.sugars100g()); }
        if (request.fiber100g() != null) { aliment.setFiber100g(request.fiber100g()); }
        if (request.protein100g() != null) { aliment.setProtein100g(request.protein100g()); }
        if (request.salt100g() != null) { aliment.setSalt100g(request.salt100g()); }

        // La update, alimentul trebuie revalidat
        aliment.setIsValidated(false);
        aliment.setNutritionScore(NutritionScore.UNKNOWN);

        return alimentMapper.toAlimentDto(alimentRepository.save(aliment));
    }

}
