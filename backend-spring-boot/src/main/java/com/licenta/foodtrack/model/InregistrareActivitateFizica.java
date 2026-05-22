package com.licenta.foodtrack.model;


import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;

@Entity
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Table(name = "inregistrari_activitati_fizice")
public class InregistrareActivitateFizica {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String nume;
    private LocalDate dataActivitate;
    private Double met;
    @Enumerated(EnumType.STRING)
    private CategorieActivitate categorie;
    private Double durataMin;
    private Double caloriiArse;
    private Integer numarPasi;
    private Double utilizatorKg;
    @Enumerated(EnumType.STRING)
    private SursaDate sursaDate;
    private String notite;

    @ManyToOne
    @JoinColumn(name = "utilizator_id")
    private Utilizator utilizator;



}
