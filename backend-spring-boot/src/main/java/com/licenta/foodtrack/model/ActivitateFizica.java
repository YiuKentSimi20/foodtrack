package com.licenta.foodtrack.model;


import jakarta.persistence.*;
import lombok.*;

@Entity
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@Table(name = "activitati_fizice")
public class ActivitateFizica {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false,  unique = true)
    private String nume;

    @Column(nullable = false)
    @Enumerated(EnumType.STRING)
    private CategorieActivitate categorie;

    @Column(nullable = false)
    private Double met;

    private String descriere;

    public static double calculeazaCaloriiArse(Double met, Double greutateKg, Double durataMinute) {
        if (met == null || greutateKg == null || durataMinute == null) {
            return 0.0;
        }

        double durataOre = durataMinute / 60.0;

        // Aplicam formula MET
        double calorii = met * greutateKg * durataOre;

        return Math.round(calorii * 100.0) / 100.0;
    }


}
