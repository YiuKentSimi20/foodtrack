package com.licenta.foodtrack.repository;

import com.licenta.foodtrack.model.Utilizator;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.Optional;
import java.util.UUID;

public interface UtilizatorRepository extends JpaRepository<Utilizator, UUID> {
    Optional<Utilizator> findByEmail(String email);

    Optional<Utilizator> findByUsernameOrEmail(String identifier, String identifier1);

    boolean existsByUsername(String username);

    boolean existsByEmail(String email);
}
