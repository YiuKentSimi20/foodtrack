package com.licenta.foodtrack.repository;

import com.licenta.foodtrack.model.CategorieMasa;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface CategorieMasaRepository extends JpaRepository<CategorieMasa, Long> {
    List<CategorieMasa> findAllByUtilizatorIdOrderByNumarOrdine(UUID idUtilizatorCurent);
}
