package com.licenta.foodtrack.repository;

import com.licenta.foodtrack.model.MasuratoareGreutate;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.PastOrPresent;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface MasuratoareGreutateRepository extends JpaRepository<MasuratoareGreutate, Long> {

    List<MasuratoareGreutate> findByUtilizatorId(UUID utilizator_id);

    boolean existsByDate(LocalDate localDate);

    Optional<MasuratoareGreutate> findByUtilizatorIdAndDate(UUID id, LocalDate localDate);
}
