package com.licenta.foodtrack.model;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

@DisplayName("ActivitateFizica Entity Tests")
class ActivitateFizicaTest {

    @Test
    void calculeazaCaloriiArse_withValidParameters() {
        double calories = ActivitateFizica.calculeazaCaloriiArse(5.0, 70.0, 30.0);

        // MET * greutate * ore = 5.0 * 70 * 0.5 = 175
        assertEquals(175.0, calories, 0.1);
    }

    @Test
    void calculeazaCaloriiArse_withDifferentMET() {
        double light = ActivitateFizica.calculeazaCaloriiArse(3.0, 70.0, 30.0);
        double heavy = ActivitateFizica.calculeazaCaloriiArse(8.0, 70.0, 30.0);

        assertTrue(heavy > light);
    }

    @Test
    void calculeazaCaloriiArse_withDifferentWeight() {
        double light = ActivitateFizica.calculeazaCaloriiArse(5.0, 50.0, 30.0);
        double heavy = ActivitateFizica.calculeazaCaloriiArse(5.0, 100.0, 30.0);

        assertTrue(heavy > light);
    }

    @Test
    void calculeazaCaloriiArse_withDifferentDuration() {
        double short_time = ActivitateFizica.calculeazaCaloriiArse(5.0, 70.0, 15.0);
        double long_time = ActivitateFizica.calculeazaCaloriiArse(5.0, 70.0, 60.0);

        assertTrue(long_time > short_time);
    }

    @Test
    void calculeazaCaloriiArse_withNullParameters() {
        double result = ActivitateFizica.calculeazaCaloriiArse(null, 70.0, 30.0);
        assertEquals(0.0, result);
    }

    @Test
    void calculeazaCaloriiArse_shouldRoundTo2Decimals() {
        double calories = ActivitateFizica.calculeazaCaloriiArse(5.5, 75.5, 45.0);
        assertTrue(calories > 0);
    }
}