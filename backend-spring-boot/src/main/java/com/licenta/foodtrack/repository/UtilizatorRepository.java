package com.licenta.foodtrack.repository;

import com.licenta.foodtrack.model.Utilizator;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface UtilizatorRepository extends JpaRepository<Utilizator, UUID> {
}
