package com.licenta.foodtrack.model;


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
    @Enumerated(EnumType.STRING)
    private NivelActivitate nivelActivitate;
    private Double indiceMasaCorporala;
    private Double rataMetabolicaBazala;
    private Double necesarCaloricMentinere;


    @OneToMany(mappedBy = "utilizator", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Obiectiv> obiective;

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

    @PrePersist
    public void prePersist() {
        if(this.role == null) {
            this.role = RolUtilizator.USER;
        }
    }

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

    public void addObiectiv(Obiectiv obiectiv) {

        if (this.obiective == null) {
            this.obiective = new ArrayList<>();
        }

        // Pentru testare omitem validarea
//        if(obiectiv.nutrientsAreValid()) {
//            obiective.add(obiectiv);
//            obiectiv.setUtilizator(this);
//        } else {
//            throw new IllegalArgumentException("Caloriile nu sunt egale cu suma caloriilor din macronutrienti.");
//        }
//
        obiectiv.setUtilizator(this);
        obiective.add(obiectiv);

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

    public Optional<Double> getLastMasuratoareGreutate() {
        return Optional.of(this.masuratoriGreutate.getLast().getGreutateKg());
    }

    public Optional<Double> getLastMasuratoareInaltime() {
        return Optional.of(this.masuratoriInaltime.getLast().getInaltimeCm());
    }

    public Optional<Double> getLastMasuratoareGrasimeCorporala() {
        return Optional.of(this.masuratoriGrasimeCorporala.getLast().getGrasimeCorporalaProcent());
    }

    public Optional<Obiectiv> getObiectivFor(LocalDate date) {

        List<Obiectiv> obiectiveInainteDeData =
                obiective.stream()
                        .filter(obiectiv -> obiectiv.getDataStart().isBefore(date) || obiectiv.getDataStart().isEqual(date))
                        .toList();

        if(obiectiveInainteDeData.isEmpty()) {
            List<Obiectiv> obiectiveDupaData =
                    obiective.stream()
                            .filter(obiectiv -> obiectiv.getDataStart().isAfter(date))
                            .toList();
            if(obiectiveDupaData.isEmpty()) {
                return Optional.empty();
            }
            return Optional.of(obiectiveDupaData.getFirst());
        }
        return Optional.of(obiectiveInainteDeData.getLast());
    }

    //TODO: Calcule pentru bmi, tdee, etc. pe baza masuratorilor si obiectivelor

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
