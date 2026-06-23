package com.licenta.foodtrack.service;

import com.licenta.foodtrack.dto.AlimentDto;
import com.licenta.foodtrack.dto.CreateAlimentRequest;
import com.licenta.foodtrack.exception.BarcodeNotFoundException;
import com.licenta.foodtrack.exception.DataNotBelongingToUserException;
import com.licenta.foodtrack.mapper.AlimentMapper;
import com.licenta.foodtrack.model.Aliment;
import com.licenta.foodtrack.model.CategorieAliment;
import com.licenta.foodtrack.model.NutritionScore;
import com.licenta.foodtrack.repository.AlimentRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Optional;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("AlimentService Unit Tests with Mockito")
class AlimentServiceTest {

    @Mock
    private AlimentRepository alimentRepository;

    @Mock
    private AlimentMapper alimentMapper;

    @Mock
    private OpenFoodFactsService openFoodFactsService;

    @InjectMocks
    private AlimentService alimentService;

    private UUID userId;
    private Aliment aliment;
    private AlimentDto alimentDto;

    @BeforeEach
    void setUp() {
        userId = UUID.randomUUID();

        aliment = new Aliment();
        aliment.setId(1L);
        aliment.setProductName("Apple");
        aliment.setCode("CODE123");
        aliment.setEnergyKcal100g(52.0);
        aliment.setProtein100g(0.3);
        aliment.setFat100g(0.2);
        aliment.setCarbohydrates100g(14.0);
        aliment.setIsValidated(true);

        alimentDto = new AlimentDto(1L, "Apple", null,"CODE123", true, 52.0, 0.3, 0.2, null,
                14.0, null, null, null, null, null, null);
    }

    @Test
    @DisplayName("addAliment should save unvalidated aliment with userId")
    void addAliment_shouldSaveUnvalidated() {
        CreateAlimentRequest request = new CreateAlimentRequest(
                "Apple", "Brand", "CODE123", 52.0, 0.3, 0.2, 14.0,
                null, null, null, null, null, null
        );

        when(alimentMapper.toAliment(request)).thenReturn(aliment);
        when(alimentRepository.existsByCode(aliment.getCode())).thenReturn(false);
        when(alimentRepository.save(any(Aliment.class))).thenReturn(aliment);
        when(alimentMapper.toDto(aliment)).thenReturn(alimentDto);

        AlimentDto result = alimentService.addAliment(request, userId);

        assertNotNull(result);
        assertEquals("Apple", result.productName());
        verify(alimentRepository).save(argThat(a -> !a.getIsValidated() && userId.equals(a.getCreatedByUserId())));
    }

    @Test
    @DisplayName("searchByBarcode should return aliment from database")
    void searchByBarcode_shouldReturnFromDB() {
        when(alimentRepository.findByCode("CODE123")).thenReturn(Optional.of(aliment));
        when(alimentMapper.toDto(aliment)).thenReturn(alimentDto);

        AlimentDto result = alimentService.searchByBarcode("CODE123", userId);

        assertNotNull(result);
        assertEquals("Apple", result.productName());
        verify(alimentRepository).findByCode("CODE123");
    }

    @Test
    @DisplayName("searchByBarcode should throw BarcodeNotFoundException")
    void searchByBarcode_shouldThrowNotFound() {
        when(alimentRepository.findByCode("INVALID")).thenReturn(Optional.empty());
        when(openFoodFactsService.getProductByBarcode("INVALID")).thenReturn(Optional.empty());

        assertThrows(BarcodeNotFoundException.class,
                () -> alimentService.searchByBarcode("INVALID", userId));
    }

    @Test
    @DisplayName("updateAliment should throw if not owned by user")
    void updateAliment_shouldThrowIfNotOwned() {
        UUID otherUserId = UUID.randomUUID();
        aliment.setCreatedByUserId(otherUserId);

        when(alimentRepository.findById(1L)).thenReturn(Optional.of(aliment));

        CreateAlimentRequest request = new CreateAlimentRequest(
                "Updated", "Brand", "CODE123", 60.0, 0.5, 0.3, 15.0,
                null, null, null, null, null, null
        );

        assertThrows(DataNotBelongingToUserException.class,
                () -> alimentService.updateAliment(request, 1L, userId));
    }

    @Test
    @DisplayName("validateAliment should set nutrition score")
    void validateAliment_shouldSetScore() {
        when(alimentRepository.findById(1L)).thenReturn(Optional.of(aliment));
        when(alimentRepository.save(any(Aliment.class))).thenReturn(aliment);
        when(alimentMapper.toDto(aliment)).thenReturn(alimentDto);

        alimentService.validateAliment(1L, NutritionScore.A);

        verify(alimentRepository).save(argThat(a -> a.getIsValidated() &&
                a.getNutritionScore() == NutritionScore.A));
    }
}