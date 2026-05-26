package com.licenta.foodtrack.model;

import org.junit.jupiter.api.Test;

import java.time.LocalDate;
import java.util.ArrayList;

import static org.junit.jupiter.api.Assertions.assertEquals;

class UtilizatorTest {

    @Test
    void calculateBmrKatchMcArdle_shouldReturnExpectedValue() {
        Utilizator utilizator = new Utilizator();
        utilizator.setMasuratoriGreutate(new ArrayList<>());
        utilizator.setMasuratoriInaltime(new ArrayList<>());
        utilizator.setMasuratoriGrasimeCorporala(new ArrayList<>());

        utilizator.addMasuratoareGreutate(new MasuratoareGreutate(1L, 70.0, LocalDate.of(2026, 5, 1), utilizator));
        utilizator.addMasuratoareGrasimeCorporala(new MasuratoareGrasimeCorporala(1L, 15.0, LocalDate.of(2026, 5, 1), utilizator));

        Double result = utilizator.calculateBmrKatchMcArdle(LocalDate.of(2026, 5, 10));

        // 370 + (21.6 * 70 * (1 - 180/100)) = 370 + (1512 * -0.8) = -839.6
        assertEquals(1655, result, 1);
    }

    @Test
    void calculateBmrKatchMcArdle_whenNoMeasurements_shouldUseZeroFallback() {
        Utilizator utilizator = new Utilizator();
        utilizator.setMasuratoriGreutate(new ArrayList<>());
        utilizator.setMasuratoriInaltime(new ArrayList<>());
        utilizator.setMasuratoriGrasimeCorporala(new ArrayList<>());

        Double result = utilizator.calculateBmrKatchMcArdle(LocalDate.of(2026, 5, 10));

        assertEquals(370.0, result, 0.0001);
    }
}