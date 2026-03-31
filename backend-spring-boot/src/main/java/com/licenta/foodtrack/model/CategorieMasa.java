package com.licenta.foodtrack.model;


import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

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

    @ManyToOne
    @JoinColumn(name = "utilizator_id")
    private Utilizator utilizator;

    public CategorieMasa(String nume, int numarOrdine) {
        this.nume = nume;
        this.numarOrdine = numarOrdine;
    }

}
