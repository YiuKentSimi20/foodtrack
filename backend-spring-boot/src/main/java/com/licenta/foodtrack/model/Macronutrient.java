package com.licenta.foodtrack.model;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public abstract class Macronutrient {
    private double caloriesPerUnit;
    private double valuePer100g;

    public double convertToCalories() {
        return caloriesPerUnit * ;
    }

}
