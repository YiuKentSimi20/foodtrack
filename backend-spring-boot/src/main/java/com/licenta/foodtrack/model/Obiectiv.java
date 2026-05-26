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

    public Double calculateTotalCalories() {
        return getFatCalories() + getCarbohydratesCalories() + getProteinCalories();
    }

    public Double calculateNetCalories(LocalDate date) {
        //asta ramane asa deocamdata si daca adaug si calorii arse calculez de acolo
        return utilizator.calculateTdee(date) - calories;
    }

    public Double calculateWeightCaloriesPerWeek(LocalDate date) {
        return -((calculateNetCalories(date) * 7) / 7700);
    }

    public Boolean nutrientsAreValid() {
        return calories == getFatCalories() + getCarbohydratesCalories() + getProteinCalories();
    }

}
