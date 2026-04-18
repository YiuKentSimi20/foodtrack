package com.licenta.foodtrack.model;


import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;
import java.util.List;

@Entity
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Table(name = "mese")
public class Masa {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String nume;
    private LocalDate dataMesei;
    private String oraMesei;
    private String notiteMasa;

    @OneToMany(mappedBy = "masa", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<InregistrareAliment> inregistrariAlimente;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "utilizator_id")
    private Utilizator utilizator;

    public Double calculateTotalCalories() {
        return inregistrariAlimente.stream()
                .mapToDouble(InregistrareAliment::calculateTotalCalories)
                .sum();
    }

    public Double getTotalEnergyKcal() {
        return inregistrariAlimente.stream()
                .mapToDouble(InregistrareAliment::getTotalEnergyKcal)
                .sum();
    }

    public Double getTotalEnergyKj() {
        return inregistrariAlimente.stream()
                .mapToDouble(InregistrareAliment::getTotalEnergyKj)
                .sum();
    }

    public Double getTotalFat() {
        return inregistrariAlimente.stream()
                .mapToDouble(InregistrareAliment::getTotalFat)
                .sum();
    }

    public Double getTotalSaturatedFat() {
        return inregistrariAlimente.stream()
                .mapToDouble(InregistrareAliment::getTotalSaturatedFat)
                .sum();
    }

    public Double getTotalCarbohydrates() {
        return inregistrariAlimente.stream()
                .mapToDouble(InregistrareAliment::getTotalCarbohydrates)
                .sum();
    }

    public Double getTotalSugars() {
        return inregistrariAlimente.stream()
                .mapToDouble(InregistrareAliment::getTotalSugars)
                .sum();
    }

    public Double getTotalFiber() {
        return inregistrariAlimente.stream()
                .mapToDouble(InregistrareAliment::getTotalFiber)
                .sum();
    }

    public Double getTotalProtein() {
        return inregistrariAlimente.stream()
                .mapToDouble(InregistrareAliment::getTotalProtein)
                .sum();
    }

    public Double getTotalSalt() {
        return inregistrariAlimente.stream()
                .mapToDouble(InregistrareAliment::getTotalSalt)
                .sum();
    }

    public Double getFatCalories() {
        return getTotalFat() * 9;
    }

    public Double getCarbohydratesCalories() {
        return getTotalCarbohydrates() * 4;
    }

    public Double getProteinCalories() {
        return getTotalProtein() * 4;
    }

    public Double getFatCaloriesPercent() {
        return calculateTotalCalories() == 0 ? 0 : (getFatCalories() / calculateTotalCalories());
    }

    public Double getCarbohydratesCaloriesPercent() {
        return calculateTotalCalories() == 0 ? 0 : (getCarbohydratesCalories() / calculateTotalCalories());
    }

    public Double getProteinCaloriesPercent() {
        return calculateTotalCalories() == 0 ? 0 : (getProteinCalories() / calculateTotalCalories());
    }

    //TODO: Calculat calorii nete in fiecare zi
    //TODO: Grupat totaluri pe zile, saptamani, luni
    //TODO: Azi fac sistemul de cereri si raspunsuri + erori

}
