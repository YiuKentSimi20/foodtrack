package com.licenta.foodtrack.repository;

import com.licenta.foodtrack.model.ActivitateFizica;
import com.licenta.foodtrack.model.InregistrareActivitateFizica;
import com.licenta.foodtrack.model.SursaDate;
import org.springframework.data.domain.Limit;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDate;
import java.util.Optional;
import java.util.UUID;

public interface InregistrariActivitatiFiziceRepository extends JpaRepository<InregistrareActivitateFizica, Long> {

    Optional<InregistrareActivitateFizica> findByIdAndUtilizatorIdAndSursaDate(Long id, UUID utilizatorId, SursaDate sursaDate);

    Optional<InregistrareActivitateFizica> findFirstByUtilizatorIdAndSursaDateAndDataActivitate(UUID utilizatorId, SursaDate sursaDate, LocalDate dataActivitate);
}
