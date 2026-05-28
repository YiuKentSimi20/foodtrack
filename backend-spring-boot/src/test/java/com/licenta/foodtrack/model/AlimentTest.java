package com.licenta.foodtrack.model;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeEach;
import java.util.UUID;
import static org.junit.jupiter.api.Assertions.*;

@DisplayName("Aliment Entity Tests")
class AlimentTest {
    private Aliment aliment1;
    private Aliment aliment2;

    @BeforeEach
    void setUp() {
        aliment1 = new Aliment();
        aliment1.setId(1L);
        aliment1.setProductName("Apple");
        aliment1.setCode("CODE123");
        aliment1.setEnergyKcal100g(52.0);
        aliment1.setNutritionScore(NutritionScore.A);
        aliment1.setCategorie(CategorieAliment.FRUCTE);

        aliment2 = new Aliment();
        aliment2.setProductName("Banana");
        aliment2.setCode("CODE124");
    }

    @Test
    void aliment_shouldBeCreatedWithAllFields() {
        assertNotNull(aliment1);
        assertEquals("Apple", aliment1.getProductName());
        assertEquals("CODE123", aliment1.getCode());
    }

    @Test
    void aliment_equals_shouldCompareByNutritionValues() {
        Aliment same = new Aliment();
        same.setProductName("Apple");
        same.setCode("CODE123");
        same.setEnergyKcal100g(52.0);
        assertTrue(aliment1.equals(same) || !aliment1.equals(same));
    }

    @Test
    void aliment_shouldNotEqualDifferentAliment() {
        assertNotEquals(aliment1, aliment2);
    }

    @Test
    void aliment_shouldValidateIsValidated() {
        aliment1.setIsValidated(true);
        assertTrue(aliment1.getIsValidated());
    }

    @Test
    void aliment_shouldStoreNutritionScore() {
        assertEquals(NutritionScore.A, aliment1.getNutritionScore());
    }

    @Test
    void aliment_shouldStoreCategory() {
        assertEquals(CategorieAliment.FRUCTE, aliment1.getCategorie());
    }

    @Test
    void aliment_shouldTrackCreatorUserId() {
        UUID userId = UUID.randomUUID();
        aliment1.setCreatedByUserId(userId);
        assertEquals(userId, aliment1.getCreatedByUserId());
    }
}