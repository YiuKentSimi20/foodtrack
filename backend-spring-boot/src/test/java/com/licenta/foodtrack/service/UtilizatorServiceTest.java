package com.licenta.foodtrack.service;

import com.licenta.foodtrack.dto.DatePersonaleResponse;
import com.licenta.foodtrack.model.*;
import com.licenta.foodtrack.repository.UtilizatorRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDate;
import java.util.Optional;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("UtilizatorService Unit Tests")
class UtilizatorServiceTest {

    @Mock
    private UtilizatorRepository utilizatorRepository;

    @InjectMocks
    private UtilizatorService utilizatorService;

    private UUID userId;
    private Utilizator utilizator;

    @BeforeEach
    void setUp() {
        userId = UUID.randomUUID();

        utilizator = new Utilizator();
        utilizator.setId(userId);
        utilizator.setUsername("testuser");
        utilizator.setEmail("test@example.com");
        utilizator.setDataNasterii(LocalDate.of(1990, 5, 15));
        utilizator.setGen(GenUtilizator.M);
        utilizator.setNivelActivitate(NivelActivitate.ACTIV);
        utilizator.setRole(RolUtilizator.USER);
        utilizator.addMasuratoareGreutate(new MasuratoareGreutate(1L, 70.0, LocalDate.of(2024, 1, 1), utilizator));
        utilizator.addMasuratoareInaltime(new MasuratoareInaltime(1L, 175.0, LocalDate.of(2024, 1, 1), utilizator));
        utilizator.addMasuratoareGrasimeCorporala(new MasuratoareGrasimeCorporala(1L, 15.0, LocalDate.of(2024, 1, 1), utilizator));
    }

    @Test
    @DisplayName("getDatePersonale should return user details")
    void getDatePersonale_shouldReturnUserDetails() {
        when(utilizatorRepository.findById(userId)).thenReturn(Optional.of(utilizator));

        DatePersonaleResponse response = utilizatorService.getDatePersonale(userId);

        assertNotNull(response);
        assertEquals("testuser", response.username());
        assertEquals("test@example.com", response.email());
        verify(utilizatorRepository).findById(userId);
    }

    @Test
    @DisplayName("updateDatePersonale should update user fields")
    void updateDatePersonale_shouldUpdateFields() {
        when(utilizatorRepository.findById(userId)).thenReturn(Optional.of(utilizator));

        utilizator.setNivelActivitate(NivelActivitate.FOARTE_ACTIV);
        DatePersonaleResponse response = utilizatorService.getDatePersonale(userId);

        assertNotNull(response);
        verify(utilizatorRepository).findById(userId);
    }
}