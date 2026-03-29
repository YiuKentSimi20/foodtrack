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

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "masa_id", nullable = false)
    private Masa masa;

}
