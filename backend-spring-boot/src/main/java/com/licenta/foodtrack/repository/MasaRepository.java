package com.licenta.foodtrack.repository;

import com.licenta.foodtrack.model.Masa;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface MasaRepository extends JpaRepository<Masa, Long> {

    List<Masa> findAllByUtilizatorId(UUID id);

    List<Masa> findAllByUtilizatorIdAndDataMeseiBetween(UUID userId, LocalDate startingDate, LocalDate endingDate);

    List<Masa> findAllByUtilizatorIdAndDataMeseiGreaterThanEqual(UUID userId, LocalDate startingDate);

    List<Masa> findAllByUtilizatorIdAndDataMeseiLessThanEqual(UUID userId, LocalDate endingDate);

    boolean existsByCategorieMasaIdAndDataMeseiAndUtilizatorId(Long CategorieMasaId, LocalDate data, UUID idUtilizatorCurent);

    Optional<Masa> findByCategorieMasaIdAndDataMeseiAndUtilizatorId(Long CategorieMasaId, LocalDate dataMesei, UUID utilizatorId);
}
