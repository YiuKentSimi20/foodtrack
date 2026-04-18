package com.licenta.foodtrack.model;


import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;

@Entity
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Table(name = "obiective")
public class Obiectiv {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private Double calories;
    private Double fat;
    private Double carbohydrates;
    private Double protein;
    private LocalDate dataStart;

    @ManyToOne(fetch = FetchType.LAZY,  cascade = CascadeType.ALL)
    @JoinColumn(name = "utilizator_id")
    private Utilizator utilizator;


    public Double getFatCalories() {
        return fat * 9;
    }

    public Double getCarbohydratesCalories() {
        return carbohydrates * 4;
    }

    public Double getProteinCalories() {
        return protein * 4;
    }

    public Double getFatCaloriesPercent() {
        return calories == 0 ? 0 : (getFatCalories() / calories) * 100;
    }

    public Double getCarbohydratesCaloriesPercent() {
        return calories == 0 ? 0 : (getCarbohydratesCalories() / calories) * 100;
    }

    public Double getProteinCaloriesPercent() {
        return calories == 0 ? 0 : (getProtein() / calories) * 100;
    }

    public Double calculateTotalCalories() {
        return getFatCalories() + getCarbohydratesCalories() + getProteinCalories();
    }

    public Double calculateNetCalories() {
        //asta ramane asa deocamdata si daca adaug si calorii arse calculez de acolo
        return utilizator.getNecesarCaloricMentinere() - calories;
    }

    public Double calculateWeightCaloriesPerWeek() {
        return (calculateTotalCalories() * 7) / 7700;
    }

    public Boolean nutrientsAreValid() {
        return calories == getFatCalories() + getCarbohydratesCalories() + getProteinCalories();
    }



}
