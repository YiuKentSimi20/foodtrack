package com.licenta.foodtrack.repository;

import com.licenta.foodtrack.model.Aliment;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface AlimentRepository extends JpaRepository<Aliment, Long> {
    boolean existsByCode(String aliment);

    Optional<Aliment> findByCode(String barcode);

    List<Aliment> findByProductNameContainingIgnoreCaseAndIsValidatedTrue(String productName);

}
