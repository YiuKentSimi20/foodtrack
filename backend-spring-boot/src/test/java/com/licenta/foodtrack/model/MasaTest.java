package com.licenta.foodtrack.model;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeEach;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import static org.junit.jupiter.api.Assertions.*;

@DisplayName("Masa Entity Tests")
class MasaTest {
    private Masa masa;
    private InregistrareAliment reg1, reg2;

    @BeforeEach
    void setUp() {
        masa = new Masa();
        masa.setId(1L);
        masa.setDataMesei(LocalDate.of(2026, 5, 28));
        masa.setInregistrariAlimente(new ArrayList<>());

        reg1 = new InregistrareAliment();
        reg1.setGrams(100.0);
        reg1.setProtein100g(10.0);
        reg1.setFat100g(5.0);
        reg1.setCarbohydrates100g(15.0);
        reg1.setEnergyKcal100g(150.0);

        reg2 = new InregistrareAliment();
        reg2.setGrams(200.0);
        reg2.setProtein100g(20.0);
        reg2.setFat100g(3.0);
        reg2.setCarbohydrates100g(25.0);
        reg2.setEnergyKcal100g(200.0);
    }

    @Test
    void masa_shouldCalculateTotalGrams() {
        masa.getInregistrariAlimente().add(reg1);
        masa.getInregistrariAlimente().add(reg2);
        assertEquals(300.0, masa.calculateTotalGrams());
    }

    @Test
    void masa_shouldCalculateTotalCalories() {
        masa.getInregistrariAlimente().add(reg1);
        Double calories = masa.calculateTotalCalories();
        assertTrue(calories > 0);
    }

    @Test
    void masa_shouldCalculateTotalProtein() {
        masa.getInregistrariAlimente().add(reg1);
        masa.getInregistrariAlimente().add(reg2);
        Double protein = masa.getTotalProtein();
        assertTrue(protein > 0);
    }

    @Test
    void masa_shouldCalculateTotalFat() {
        masa.getInregistrariAlimente().add(reg1);
        Double fat = masa.getTotalFat();
        assertTrue(fat > 0);
    }

    @Test
    void masa_shouldCalculateFruitGrams() {
        reg1.setCategorie(CategorieAliment.FRUCTE);
        masa.getInregistrariAlimente().add(reg1);
        Double fruitGrams = masa.getTotalFruitsGrams();
        assertEquals(100.0, fruitGrams);
    }

    @Test
    void masa_shouldCalculateVegetableGrams() {
        reg1.setCategorie(CategorieAliment.LEGUME);
        masa.getInregistrariAlimente().add(reg1);
        Double vegGrams = masa.getTotalVegetablesGrams();
        assertEquals(100.0, vegGrams);
    }

    @Test
    void masa_shouldReturnZeroWhenEmpty() {
        assertEquals(0.0, masa.calculateTotalGrams());
        assertEquals(0.0, masa.calculateTotalCalories());
    }
}