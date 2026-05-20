package com.licenta.foodtrack.repository;

import com.licenta.foodtrack.model.ActivitateFizica;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

public interface ActivitateFizicaRepository extends JpaRepository<ActivitateFizica, Long> {
}
