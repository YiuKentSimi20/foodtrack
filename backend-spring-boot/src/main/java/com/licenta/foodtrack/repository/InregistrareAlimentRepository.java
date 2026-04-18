package com.licenta.foodtrack.repository;

import com.licenta.foodtrack.model.InregistrareAliment;
import com.licenta.foodtrack.model.TipInregistrare;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface InregistrareAlimentRepository extends JpaRepository<InregistrareAliment, Long> {

    Optional<InregistrareAliment> findByIdAndTipInregistrare(Long id, TipInregistrare tipInregistrare);
}
