package com.licenta.foodtrack.repository;

import com.licenta.foodtrack.model.Utilizator;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UtilizatorRepository extends JpaRepository<Utilizator, Long> {
}
