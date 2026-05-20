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

    @OneToMany(mappedBy = "utilizator", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<InregistrareActivitateFizica> activitatiFizice;

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

        addCategoriiMasa(new CategorieMasa("Mic Dejun", 1, true));
        addCategoriiMasa(new CategorieMasa("Pranz", 2, true));
        addCategoriiMasa(new CategorieMasa("Cina", 3, true));
        addCategoriiMasa(new CategorieMasa("Gustare", 4, true));
        addCategoriiMasa(new CategorieMasa("Masa 1", 5, false));
        addCategoriiMasa(new CategorieMasa("Masa 2", 6, false));
        addCategoriiMasa(new CategorieMasa("Masa 3", 7, false));
        addCategoriiMasa(new CategorieMasa("Masa 4", 8, false));
        addCategoriiMasa(new CategorieMasa("Masa 5", 9, false));
    }

    public void addObiectiv(Obiectiv obiectiv) {

        if (this.obiective == null) {
            this.obiective = new ArrayList<>();
        }

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
        return Optional.of(this.masuratoriGreutate.isEmpty() ?
                0.0 : this.masuratoriGreutate.getLast().getGreutateKg());
    }

    public Optional<Double> getLastMasuratoareInaltime() {
        return Optional.of(this.masuratoriInaltime.isEmpty() ?
                0.0 : this.masuratoriInaltime.getLast().getInaltimeCm());
    }

    public Optional<Double> getLastMasuratoareGrasimeCorporala() {
        return Optional.of(this.masuratoriGrasimeCorporala.isEmpty() ?
                0.0 : this.masuratoriGrasimeCorporala.getLast().getGrasimeCorporalaProcent());
    }

    public Optional<Double> getMasuratoareGreutateFor(LocalDate date) {

        List<MasuratoareGreutate> masuratoriInainteDeData =
                masuratoriGreutate.stream()
                        .filter(masuratoare -> masuratoare.getDate().isBefore(date) || masuratoare.getDate().isEqual(date))
                        .toList();

        if(masuratoriInainteDeData.isEmpty()) {
            List<MasuratoareGreutate> masuratoriDupaData =
                    masuratoriGreutate.stream()
                            .filter(masuratoare -> masuratoare.getDate().isAfter(date))
                            .toList();
            if(masuratoriDupaData.isEmpty()) {
                return Optional.empty();
            }

            return Optional.of(masuratoriDupaData.getFirst().getGreutateKg());

        }

        return Optional.of(masuratoriInainteDeData.getLast().getGreutateKg());
    }

    public Optional<Double> getMasuratoareInaltimeFor(LocalDate date) {

        List<MasuratoareInaltime> masuratoriInainteDeData =
                masuratoriInaltime.stream()
                        .filter(masuratoare -> masuratoare.getDate().isBefore(date) || masuratoare.getDate().isEqual(date))
                        .toList();

        if(masuratoriInainteDeData.isEmpty()) {
            List<MasuratoareInaltime> masuratoriDupaData =
                    masuratoriInaltime.stream()
                            .filter(masuratoare -> masuratoare.getDate().isAfter(date))
                            .toList();
            if(masuratoriDupaData.isEmpty()) {
                return Optional.empty();
            }

            return Optional.of(masuratoriDupaData.getFirst().getInaltimeCm());
        }

        return Optional.of(masuratoriInainteDeData.getLast().getInaltimeCm());
    }

    public Optional<Double> getMasuratoareGrasimeCorporalaFor(LocalDate date) {

        List<MasuratoareGrasimeCorporala> masuratoriInainteDeData =
                masuratoriGrasimeCorporala.stream()
                        .filter(masuratoare -> masuratoare.getDate().isBefore(date) || masuratoare.getDate().isEqual(date))
                        .toList();

        if(masuratoriInainteDeData.isEmpty()) {
            List<MasuratoareGrasimeCorporala> masuratoriInaltimeDupaData =
                    masuratoriGrasimeCorporala.stream()
                            .filter(masuratoare -> masuratoare.getDate().isAfter(date))
                            .toList();
            if(masuratoriInaltimeDupaData.isEmpty()) {
                return Optional.empty();
            }

            return Optional.of(masuratoriInaltimeDupaData.getFirst().getGrasimeCorporalaProcent());
        }

        return Optional.of(masuratoriInainteDeData.getLast().getGrasimeCorporalaProcent());
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

    public Double calculateBmi() {

        return getLastMasuratoareGreutate().orElse(0.0) / Math.pow(getLastMasuratoareInaltime().orElse(1.0) / 100, 2);
    }

    public Double calculateBmr() {

        return 10 * getLastMasuratoareGreutate().orElse(0.0)
                + 6.25 * getLastMasuratoareInaltime().orElse(0.0)
                - 5 * (LocalDate.now().getYear() - dataNasterii.getYear())
                + (gen == GenUtilizator.M ? 5 : -161);
    }

    public Double calculateTdee() {
        double bmr = calculateBmr();
        return switch (nivelActivitate != null ? nivelActivitate : NivelActivitate.SEDENTAR ) {
            case SEDENTAR -> bmr * 1.2;
            case MAI_PUTIN_ACTIV -> bmr * 1.375;
            case ACTIV -> bmr * 1.55;
            case FOARTE_ACTIV -> bmr * 1.725;
        };
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {

        return List.of(() -> role.name());
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
