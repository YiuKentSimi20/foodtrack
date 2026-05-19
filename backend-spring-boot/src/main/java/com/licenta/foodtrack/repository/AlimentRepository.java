package com.licenta.foodtrack.repository;

import com.licenta.foodtrack.dto.AlimentDto;
import com.licenta.foodtrack.model.Aliment;
import com.licenta.foodtrack.service.AlimentService;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface AlimentRepository extends JpaRepository<Aliment, Long> {
    boolean existsByCode(String aliment);

    Optional<Aliment> findByCode(String barcode);

    List<Aliment> findByProductNameContainingIgnoreCaseAndIsValidatedTrue(String productName);

    List<Aliment> findByProductNameContainingIgnoreCaseAndCreatedByUserIdAndIsValidatedFalse(String productName, UUID userId);

    List<Aliment> findAllByCreatedByUserId(UUID createdByUserId);

    List<Aliment> findAllByIsValidatedFalse(UUID id);
}
