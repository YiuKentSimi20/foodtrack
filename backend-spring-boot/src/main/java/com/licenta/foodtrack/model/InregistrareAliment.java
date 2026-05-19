package com.licenta.foodtrack.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Table(name = "inregistrari_alimente")
public class InregistrareAliment {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private Double grams;
    private String productName;
    private String brands;
    private String code;
    private Double energyKcal100g;
    private Double energyKj100g;
    private Double fat100g;
    private Double saturatedFat100g;
    private Double carbohydrates100g;
    private Double sugars100g;
    private Double fiber100g;
    private Double protein100g;
    private Double salt100g;
    @Enumerated(EnumType.STRING)
    private NutritionScore nutritionScore;
    @Enumerated(EnumType.STRING)
    private CategorieAliment categorie;
    @Enumerated(EnumType.STRING)
    private TipInregistrare tipInregistrare;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "masa_id", nullable = false)
    private Masa masa;

    @PrePersist
    public void prePersist() {
        if (this.tipInregistrare == null) {
            tipInregistrare = TipInregistrare.CATALOG;
        }
    }

    public Double calculateTotalCalories() {
        return getFatCalories() + getCarbohydratesCalories() + getProteinCalories();
    }

    public Double calculateTotalEnergyKj() {
        Double fatEnergy = fat100g * 37 * (grams / 100);
        Double carbohydratesEnergy = carbohydrates100g * 17 * (grams / 100);
        Double proteinEnergy = protein100g * 17 * (grams / 100);

        return fatEnergy + carbohydratesEnergy + proteinEnergy;
    }

    public Double getFatCalories() {
        return safe(fat100g) * 9 * (safe(grams) / 100);
    }

    public Double getCarbohydratesCalories() {
        return safe(carbohydrates100g) * 4 * (safe(grams) / 100);
    }

    public Double getProteinCalories() {
        return safe(protein100g) * 4 * (safe(grams) / 100);
    }

    public Double getFatCaloriesPercent() {
        Double totalEnergy = safe(getTotalEnergyKcal());
        return calculateTotalCalories() == 0 ? 0 : getFatCalories() / calculateTotalCalories();
    }

    public Double getCarbohydratesCaloriesPercent() {
        Double totalEnergy = safe(getTotalEnergyKcal());
        return calculateTotalCalories() == 0 ? 0 : getCarbohydratesCalories() / calculateTotalCalories();
    }

    public Double getProteinCaloriesPercent() {
        Double totalEnergy = safe(getTotalEnergyKcal());
        return calculateTotalCalories() == 0 ? 0 : getProteinCalories() / calculateTotalCalories();
    }

    public Double getTotalFrom100g(Double data100g) {
        return safe(data100g) * (safe(grams) / 100);
    }

    public Double getTotalEnergyKcal() {
        return safe(energyKcal100g) * (safe(grams) / 100);
    }

    public Double getTotalEnergyKj() {
        return safe(energyKj100g) * (safe(grams) / 100);
    }

    public Double getTotalFat() {
        return safe(fat100g) * (safe(grams) / 100);
    }

    public Double getTotalSaturatedFat() {
        return safe(saturatedFat100g) * (safe(grams) / 100);
    }

    public Double getTotalCarbohydrates() {
        return safe(carbohydrates100g) * (safe(grams) / 100);
    }

    public Double getTotalSugars() {
        return safe(sugars100g) * (safe(grams) / 100);
    }

    public Double getTotalFiber() {
        return safe(fiber100g) * (safe(grams) / 100);
    }

    public Double getTotalProtein() {
        return safe(protein100g) * (safe(grams) / 100);
    }

    public Double getTotalSalt() {
        return safe(salt100g) * (safe(grams) / 100);
    }

    public Double getUnsaturatedFat100g() {
        if (fat100g == null || saturatedFat100g == null) {
            return null;
        }
        return fat100g - saturatedFat100g;
    }

    public Double getTotalUnsaturatedFat() {
        return getUnsaturatedFat100g() * (safe(grams) / 100);
    }

    public Boolean nutrientsAreValid() {
        return getTotalEnergyKcal() == getProteinCalories() + getCarbohydratesCalories() + getFatCalories();
    }

    public Double safe(Double data) {
        if (data == null) {
            return 0d;
        }

        return data;
    }

}
