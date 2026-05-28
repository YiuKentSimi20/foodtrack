package com.licenta.foodtrack.model;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeEach;
import static org.junit.jupiter.api.Assertions.*;

@DisplayName("InregistrareAliment Entity Tests")
class InregistrareAlimentTest {
    private InregistrareAliment reg;

    @BeforeEach
    void setUp() {
        reg = new InregistrareAliment();
        reg.setGrams(100.0);
        reg.setProtein100g(20.0);
        reg.setFat100g(10.0);
        reg.setCarbohydrates100g(30.0);
        reg.setEnergyKcal100g(250.0);
        reg.setSalt100g(0.5);
    }

    @Test
    void registration_shouldCalculateTotalCalories() {
        Double calories = reg.calculateTotalCalories();
        assertTrue(calories > 0);
    }

    @Test
    void registration_shouldCalculateFatCalories() {
        Double fatCal = reg.getFatCalories();
        assertEquals(10.0 * 9 * (100.0 / 100), fatCal);
    }

    @Test
    void registration_shouldCalculateProteinCalories() {
        Double protCal = reg.getProteinCalories();
        assertEquals(20.0 * 4 * (100.0 / 100), protCal);
    }

    @Test
    void registration_shouldCalculateCarbsCalories() {
        Double carbCal = reg.getCarbohydratesCalories();
        assertEquals(30.0 * 4 * (100.0 / 100), carbCal);
    }

    @Test
    void registration_shouldCalculateTotalProtein() {
        Double totalProtein = reg.getTotalProtein();
        assertEquals(20.0, totalProtein);
    }

    @Test
    void registration_shouldCalculateTotalFat() {
        Double totalFat = reg.getTotalFat();
        assertEquals(10.0, totalFat);
    }

    @Test
    void registration_shouldCalculateTotalSalt() {
        Double totalSalt = reg.getTotalSalt();
        assertEquals(0.5, totalSalt);
    }

    @Test
    void registration_shouldReturnZeroWhenNoGrams() {
        reg.setGrams(0.0);
        assertEquals(0.0, reg.getTotalProtein());
        assertEquals(0.0, reg.getTotalFat());
    }

    @Test
    void registration_shouldDefaultToCatalogType() {
        reg.prePersist();
        assertEquals(TipInregistrare.CATALOG, reg.getTipInregistrare());
    }
}