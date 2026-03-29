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
@Table(name = "utilizatori")
public class Utilizator {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true, nullable = false)
    private String username;
    @Column(unique = true, nullable = false)
    private String email;
    @Column(nullable = false)
    private String password;
    @Column(nullable = false)
    private LocalDate dataNasterii;
    @Enumerated(EnumType.STRING)
    private GenUtilizator gen;
    private Double obiectivCaloriiZi;
    private Double obiectivGreutateKg;
    private Double obiectivProteineZi;
    private Double obiectivCarbohidratiZi;
    private Double obiectivGrasimiZi;
    @Enumerated(EnumType.STRING)
    private NivelActivitate nivelActivitate;
    private Double indiceMasaCorporala;
    private Double rataMetabolicaBazala;
    private Double tdee;

    @OneToMany(mappedBy = "utilizator", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<MasuratoareGreutate>  masuratoriGreutate;

    @OneToMany(mappedBy = "utilizator", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<MasuratoareGrasimeCorporala> masuratoriGrasimeCorporal;

    @OneToMany(mappedBy = "utilizator", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<MasuratoareInaltime> masuratoriInaltime;


    @OneToMany(mappedBy = "utilizator", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Masa> listaMese;

}
