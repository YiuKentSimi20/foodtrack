package com.licenta.foodtrack.model;


import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Entity
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Table(name = "categorii_mese")
public class CategorieMasa {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String nume;

    private Integer numarOrdine;
    private Boolean isActive;

    @ManyToOne
    @JoinColumn(name = "utilizator_id")
    private Utilizator utilizator;

    @OneToMany(mappedBy = "categorieMasa", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Masa> listaMese;

    public CategorieMasa(String nume, int numarOrdine, Boolean isActive) {

        this.nume = nume;
        this.numarOrdine = numarOrdine;
        this.isActive = isActive;
    }
}
