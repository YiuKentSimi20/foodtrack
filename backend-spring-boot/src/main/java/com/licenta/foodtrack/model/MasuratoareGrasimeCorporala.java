package com.licenta.foodtrack.model;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;

@Entity
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Table(name = "masuratori_grasime_corporala")
public class MasuratoareGrasimeCorporala {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private Double greutateKg;
    private LocalDate date;

    @ManyToOne(fetch = FetchType.LAZY,  cascade = CascadeType.ALL)
    @JoinColumn(name = "utilizator_id")
    private Utilizator utilizator;

}
