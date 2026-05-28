package com.licenta.foodtrack.model;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.Nested;

import java.time.LocalDate;
import java.util.ArrayList;

import static org.junit.jupiter.api.Assertions.*;

@DisplayName("Utilizator Tests")
class UtilizatorTest {

    private Utilizator utilizator;

    @BeforeEach
    void setUp() {
        utilizator = new Utilizator();
        utilizator.setMasuratoriGreutate(new ArrayList<>());
        utilizator.setMasuratoriInaltime(new ArrayList<>());
        utilizator.setMasuratoriGrasimeCorporala(new ArrayList<>());
        utilizator.setDataNasterii(LocalDate.of(1990, 5, 15));
        utilizator.setGen(GenUtilizator.M);
        utilizator.setNivelActivitate(NivelActivitate.SEDENTAR);
    }

    @Nested
    @DisplayName("BMR Calculations")
    class BMRTests {

        @Test
        @DisplayName("calculateBmrKatchMcArdle with measurements should return correct value")
        void calculateBmrKatchMcArdle_shouldReturnExpectedValue() {
            utilizator.addMasuratoareGreutate(new MasuratoareGreutate(1L, 70.0, LocalDate.of(2026, 5, 1), utilizator));
            utilizator.addMasuratoareInaltime(new MasuratoareInaltime(1L, 180.0, LocalDate.of(2026, 5, 1), utilizator));
            utilizator.addMasuratoareGrasimeCorporala(new MasuratoareGrasimeCorporala(1L, 15.0, LocalDate.of(2026, 5, 1), utilizator));

            Double result = utilizator.calculateBmrKatchMcArdle(LocalDate.of(2026, 5, 10));

            // 370 + (21.6 * 70 * (1 - 15/100)) = 370 + (1512 * 0.85) = 1655.2
            assertEquals(1655.2, result, 0.1);
        }

        @Test
        @DisplayName("calculateBmrKatchMcArdle without measurements should return 370")
        void calculateBmrKatchMcArdle_whenNoMeasurements_shouldUseZeroFallback() {
            Double result = utilizator.calculateBmrKatchMcArdle(LocalDate.of(2026, 5, 10));
            assertEquals(370.0, result, 0.0001);
        }

        @Test
        @DisplayName("calculateBmrHarrisBenedict for male should be correct")
        void calculateBmrHarrisBenedict_forMale_shouldBeCorrect() {
            utilizator.setGen(GenUtilizator.M);
            utilizator.addMasuratoareGreutate(new MasuratoareGreutate(1L, 75.0, LocalDate.of(2026, 5, 1), utilizator));
            utilizator.addMasuratoareInaltime(new MasuratoareInaltime(1L, 180.0, LocalDate.of(2026, 5, 1), utilizator));

            Double result = utilizator.calculateBmrHarrisBenedict(LocalDate.of(2026, 5, 1));

            // 10 * 75 + 6.25 * 180 - 5 * 36 + 5 = 750 + 1125 - 180 + 5 = 1700
            assertEquals(1700.0, result, 1.0);
        }

        @Test
        @DisplayName("calculateBmr should use KatchMcArdle when body fat available")
        void calculateBmr_whenGrasimeAvailable_shouldUseKatchMcArdle() {
            utilizator.addMasuratoareGreutate(new MasuratoareGreutate(1L, 70.0, LocalDate.of(2026, 5, 1), utilizator));
            utilizator.addMasuratoareInaltime(new MasuratoareInaltime(1L, 180.0, LocalDate.of(2026, 5, 1), utilizator));
            utilizator.addMasuratoareGrasimeCorporala(new MasuratoareGrasimeCorporala(1L, 15.0, LocalDate.of(2026, 5, 1), utilizator));

            Double result = utilizator.calculateBmr(LocalDate.of(2026, 5, 1));

            // Should use KatchMcArdle formula
            assertTrue(result > 1600 && result < 1700);
        }
    }

    @Nested
    @DisplayName("BMI Calculations")
    class BMITests {

        @Test
        @DisplayName("calculateBmi should return correct value")
        void calculateBmi_shouldReturnCorrectValue() {
            utilizator.addMasuratoareGreutate(new MasuratoareGreutate(1L, 70.0, LocalDate.of(2026, 5, 1), utilizator));
            utilizator.addMasuratoareInaltime(new MasuratoareInaltime(1L, 180.0, LocalDate.of(2026, 5, 1), utilizator));

            Double result = utilizator.calculateBmi();

            // BMI = 70 / (1.80^2) = 21.6
            assertEquals(21.6, result, 0.1);
        }

        @Test
        @DisplayName("calculateBmi without measurements should return 0")
        void calculateBmi_withoutMeasurements_shouldReturnZero() {
            Double result = utilizator.calculateBmi();

            // 0 / 0^2 = 0
            assertEquals(0.0, result, 0.0001);
        }
    }

    @Nested
    @DisplayName("TDEE Calculations")
    class TDEETests {

        @Test
        @DisplayName("calculateTdee for sedentary should multiply BMR by 1.2")
        void calculateTdee_forSedentary_shouldMultiplyBy1_2() {
            utilizator.setNivelActivitate(NivelActivitate.SEDENTAR);
            utilizator.addMasuratoareGreutate(new MasuratoareGreutate(1L, 70.0, LocalDate.of(2026, 5, 1), utilizator));
            utilizator.addMasuratoareInaltime(new MasuratoareInaltime(1L, 180.0, LocalDate.of(2026, 5, 1), utilizator));
            utilizator.addMasuratoareGrasimeCorporala(new MasuratoareGrasimeCorporala(1L, 15.0, LocalDate.of(2026, 5, 1), utilizator));

            Double tdee = utilizator.calculateTdee(LocalDate.of(2026, 5, 1));
            Double bmr = utilizator.calculateBmr(LocalDate.of(2026, 5, 1));

            assertEquals(bmr * 1.2, tdee, 1.0);
        }

        @Test
        @DisplayName("calculateTdee for active should multiply BMR by 1.55")
        void calculateTdee_forActive_shouldMultiplyBy1_55() {
            utilizator.setNivelActivitate(NivelActivitate.ACTIV);
            utilizator.addMasuratoareGreutate(new MasuratoareGreutate(1L, 70.0, LocalDate.of(2026, 5, 1), utilizator));
            utilizator.addMasuratoareInaltime(new MasuratoareInaltime(1L, 180.0, LocalDate.of(2026, 5, 1), utilizator));
            utilizator.addMasuratoareGrasimeCorporala(new MasuratoareGrasimeCorporala(1L, 15.0, LocalDate.of(2026, 5, 1), utilizator));

            Double tdee = utilizator.calculateTdee(LocalDate.of(2026, 5, 1));
            Double bmr = utilizator.calculateBmr(LocalDate.of(2026, 5, 1));

            assertEquals(bmr * 1.55, tdee, 1.0);
        }
    }

    @Nested
    @DisplayName("Age Calculations")
    class AgeTests {

        @Test
        @DisplayName("getVarsta should return correct age")
        void getVarsta_shouldReturnCorrectAge() {
            utilizator.setDataNasterii(LocalDate.of(1990, 5, 15));

            int age = utilizator.getVarsta();

            // Current year is 2026, born in 1990 = 36 years old
            assertEquals(36, age);
        }

        @Test
        @DisplayName("getVarsta for newborn should return 0")
        void getVarsta_forNewborn_shouldReturnZero() {
            utilizator.setDataNasterii(LocalDate.of(2026, 5, 28));

            int age = utilizator.getVarsta();

            assertEquals(0, age);
        }
    }

    @Nested
    @DisplayName("Measurement Management")
    class MeasurementTests {

        @Test
        @DisplayName("getLastMasuratoareGreutate should return most recent weight")
        void getLastMasuratoareGreutate_shouldReturnMostRecent() {
            utilizator.addMasuratoareGreutate(new MasuratoareGreutate(1L, 70.0, LocalDate.of(2026, 5, 1), utilizator));
            utilizator.addMasuratoareGreutate(new MasuratoareGreutate(2L, 72.0, LocalDate.of(2026, 5, 15), utilizator));

            Double result = utilizator.getLastMasuratoareGreutate().orElse(0.0);

            assertEquals(72.0, result);
        }

        @Test
        @DisplayName("getMasuratoareGreutateFor should return closest measurement before date")
        void getMasuratoareGreutateFor_shouldReturnClosestBefore() {
            utilizator.addMasuratoareGreutate(new MasuratoareGreutate(1L, 70.0, LocalDate.of(2026, 5, 1), utilizator));
            utilizator.addMasuratoareGreutate(new MasuratoareGreutate(2L, 72.0, LocalDate.of(2026, 5, 15), utilizator));

            Double result = utilizator.getMasuratoareGreutateFor(LocalDate.of(2026, 5, 10)).orElse(0.0);

            assertEquals(70.0, result);
        }
    }
}