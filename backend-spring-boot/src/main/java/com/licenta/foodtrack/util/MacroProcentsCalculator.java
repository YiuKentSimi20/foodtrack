package com.licenta.foodtrack.util;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

public class MacroProcentsCalculator {

    public record MacroPercents(Double fatPercent, Double carbsPercent, Double proteinPercent) {}

    public static MacroPercents calcPercentsSumOne(
            double fat,
            double carbs,
            double protein
    ) {
        double fatCalories = fat * 9;
        double carbsCalories = carbs * 4;
        double proteinCalories = protein * 4;
        double total = fatCalories + carbsCalories + proteinCalories;

        if (total <= 0) {
            return new MacroPercents(0.0, 0.0, 0.0);
        }

        // Procente brute in [0, 1]
        double[] raw = new double[3];
        raw[0] = fatCalories / total;
        raw[1] = carbsCalories / total;
        raw[2] = proteinCalories / total;

        // Taiere la 2 zecimale (floor)
        double[] floored = new double[3];
        double[] frac = new double[3];
        double sumFloor = 0;

        for (int i = 0; i < 3; i++) {
            floored[i] = Math.floor(raw[i] * 100) / 100.0;
            frac[i] = raw[i] - floored[i];
            sumFloor += floored[i];
        }

        // Cate unitati de 0.01 lipsesc pana la 1.00
        double remainder = 1.0 - sumFloor;
        int stepsOfPointZeroOne = Math.toIntExact(Math.round(remainder * 100));

        // Distribuie +0.01 la cei cu partea fractionara cea mai mare
        List<Integer> idx = new ArrayList<>(List.of(0, 1, 2));
        idx.sort(Comparator.comparingDouble((Integer i) -> frac[i]).reversed());

        for (int i = 0; i < stepsOfPointZeroOne; i++) {
            int k = idx.get(i % 3);
            floored[k] += 0.01;
        }

        // Normalizare finala (suma exact 1.00)
        double finalSum = floored[0] + floored[1] + floored[2];
        double diff = 1.0 - finalSum;
        if (Math.abs(diff) > 0.001) { // toleranta numerica
            floored[0] += diff;
        }

        // Rotunjire la 2 zecimale pentru siguranta
        floored[0] = Math.round(floored[0] * 100) / 100.0;
        floored[1] = Math.round(floored[1] * 100) / 100.0;
        floored[2] = Math.round(floored[2] * 100) / 100.0;

        return new MacroPercents(floored[0], floored[1], floored[2]);
    }
}
