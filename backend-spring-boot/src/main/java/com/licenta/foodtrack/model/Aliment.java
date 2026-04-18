package com.licenta.foodtrack.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.Objects;
import java.util.UUID;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@Entity
@Table(
        name = "alimente",
        uniqueConstraints = {
                @UniqueConstraint(columnNames = "code")
        }
)
public class Aliment {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String productName;
    private String brands;
    @Column(unique = true)
    private String code;
    @Column(columnDefinition = "BOOLEAN DEFAULT TRUE")
    private Boolean isValidated;
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
    private UUID createdByUserId;

    @Override
    public boolean equals(Object o) {
        if (o == null || getClass() != o.getClass()) return false;
        Aliment aliment = (Aliment) o;
        return Objects.equals(productName, aliment.productName) && Objects.equals(code, aliment.code) && Objects.equals(energyKcal100g, aliment.energyKcal100g) && Objects.equals(energyKj100g, aliment.energyKj100g) && Objects.equals(fat100g, aliment.fat100g) && Objects.equals(saturatedFat100g, aliment.saturatedFat100g) && Objects.equals(carbohydrates100g, aliment.carbohydrates100g) && Objects.equals(sugars100g, aliment.sugars100g) && Objects.equals(fiber100g, aliment.fiber100g) && Objects.equals(protein100g, aliment.protein100g) && Objects.equals(salt100g, aliment.salt100g) && nutritionScore == aliment.nutritionScore;
    }

    @Override
    public int hashCode() {
        return Objects.hash(id, productName, code, energyKcal100g, energyKj100g, fat100g, saturatedFat100g, carbohydrates100g, sugars100g, fiber100g, protein100g, salt100g, nutritionScore);
    }
}


