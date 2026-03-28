package com.licenta.foodtrack.service;

import com.licenta.foodtrack.dto.OffBarcodeResponse;
import com.licenta.foodtrack.mapper.AlimentMapper;
import com.licenta.foodtrack.model.Aliment;
import com.licenta.foodtrack.repository.AlimentRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class FoodTrackService {

    private final OpenFoodFactsService openFoodFactsService;
    private final AlimentMapper alimentMapper;
    private final AlimentRepository alimentRepository;

    public List<Aliment> searchByNameMock(String name) {

        List<Aliment> alimente = alimentRepository.findByProductNameContainingIgnoreCase(name);

        openFoodFactsService.searchProductsMock(name)
                .stream()
                .filter(offProduct -> offProduct.nutriments() != null)
                .map(alimentMapper::toAliment)
                .filter(aliment -> !alimente.contains(aliment))
                .map(alimentRepository::save)
                .forEach(alimente::add);

        return alimente;
    }

    public List<Aliment> searchByName(String name) {

        List<Aliment> alimente = alimentRepository.findByProductNameContainingIgnoreCase(name);

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

    public Optional<Aliment> searchByBarcode(String barcode) {
        // Se cauta in baza de date. Daca nu se gaseste, se apeleaza API-ul OFF
        // Daca API-ul returneaza un produs valid, se salveaza in baza de date si se returneaza
        return alimentRepository.findByCode(barcode)
                .or(() -> openFoodFactsService.getProductByBarcode(barcode)
                        .map(OffBarcodeResponse::product)
                        .map(alimentMapper::toAliment)
                        .filter(a -> a.getCode() != null && !a.getCode().isBlank())
                        .filter(a -> !alimentRepository.existsByCode(a.getCode()))
                        .map(alimentRepository::save));
    }
}
