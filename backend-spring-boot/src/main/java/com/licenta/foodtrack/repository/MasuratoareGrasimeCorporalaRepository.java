package com.licenta.foodtrack.repository;

import com.licenta.foodtrack.model.MasuratoareGrasimeCorporala;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.PastOrPresent;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface MasuratoareGrasimeCorporalaRepository extends JpaRepository<MasuratoareGrasimeCorporala, Long> {

    List<MasuratoareGrasimeCorporala> findByUtilizatorId(UUID utilizator_id);

    Optional<MasuratoareGrasimeCorporala> findByUtilizatorIdAndDate(UUID id, LocalDate localDate);
}
