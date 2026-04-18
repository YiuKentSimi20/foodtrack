package com.licenta.foodtrack.repository;

import com.licenta.foodtrack.model.MasuratoareInaltime;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.PastOrPresent;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface MasuratoareInaltimeRepository extends JpaRepository<MasuratoareInaltime, Long> {

    List<MasuratoareInaltime> findByUtilizatorId(UUID utilizator_id);

    Optional<MasuratoareInaltime> findByUtilizatorIdAndDate(UUID id, LocalDate localDate);
}
