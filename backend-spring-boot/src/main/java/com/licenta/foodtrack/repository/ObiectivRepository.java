package com.licenta.foodtrack.repository;

import com.licenta.foodtrack.dto.MasuratoareGreutateDto;
import com.licenta.foodtrack.model.Obiectiv;
import io.micrometer.common.KeyValues;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface ObiectivRepository extends JpaRepository<Obiectiv, Long> {
    List<Obiectiv> findByUtilizatorId(UUID id);

    Optional<Obiectiv> findByUtilizatorIdAndDataStart(UUID utilizatorId, LocalDate dataStart);

    UUID id(Long id);
}
