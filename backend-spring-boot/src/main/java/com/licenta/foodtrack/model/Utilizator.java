package com.licenta.foodtrack.model;


import jakarta.annotation.PreDestroy;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.time.LocalDate;
import java.util.*;

@Entity
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Table(name = "utilizatori")
public class Utilizator implements UserDetails {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(unique = true, nullable = false)
    private String username;
    @Column(unique = true, nullable = false)
    private String email;
    @Column(nullable = false)
    private String password;
    @Enumerated(EnumType.STRING)
    private RolUtilizator role;
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
    private Double necesarCaloricMentinere;

    @OneToMany(mappedBy = "utilizator", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<CategorieMasa> categoriiMese;

    @OneToMany(mappedBy = "utilizator", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<MasuratoareGreutate>  masuratoriGreutate;

    @OneToMany(mappedBy = "utilizator", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<MasuratoareGrasimeCorporala> masuratoriGrasimeCorporala;

    @OneToMany(mappedBy = "utilizator", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<MasuratoareInaltime> masuratoriInaltime;

    @OneToMany(mappedBy = "utilizator", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Masa> listaMese;

    public void addCategoriiMasa(CategorieMasa categorieMasa) {
        if (this.categoriiMese == null) {
            this.categoriiMese = new ArrayList<>();
        }
        categoriiMese.add(categorieMasa);
        categorieMasa.setUtilizator(this);
    }

    public void initCategoriiMeseDefaultIfEmpty() {

        if (this.categoriiMese != null) {
            return;
        }

        addCategoriiMasa(new CategorieMasa("Mic Dejun", 1));
        addCategoriiMasa(new CategorieMasa("Pranz", 2));
        addCategoriiMasa(new CategorieMasa("Cina", 3));
        addCategoriiMasa(new CategorieMasa("Gustare", 4));
    }

    public void addMasuratoareGreutate(MasuratoareGreutate masuratoareGreutate) {

        if (this.masuratoriGreutate == null) {
            this.masuratoriGreutate = new ArrayList<>();
        }

        masuratoriGreutate.add(masuratoareGreutate);
        masuratoareGreutate.setUtilizator(this);
    }

    public void addMasuratoareInaltime(MasuratoareInaltime masuratoareInaltime) {

        if (this.masuratoriInaltime == null) {
            this.masuratoriInaltime = new ArrayList<>();
        }

        masuratoriInaltime.add(masuratoareInaltime);
        masuratoareInaltime.setUtilizator(this);
    }

    public void addMasuratoareGrasimeCorporala(MasuratoareGrasimeCorporala grasimeCorporala) {

        if (this.masuratoriGrasimeCorporala == null) {
            this.masuratoriGrasimeCorporala = new ArrayList<>();
        }

        masuratoriGrasimeCorporala.add(grasimeCorporala);
        grasimeCorporala.setUtilizator(this);
    }

    @PrePersist
    public void prePersist() {
        if(this.role == null) {
            this.role = RolUtilizator.USER;
        }
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return List.of();
    }

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        return true;
    }
}
