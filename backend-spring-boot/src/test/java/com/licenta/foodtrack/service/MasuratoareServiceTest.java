package com.licenta.foodtrack.service;

import com.licenta.foodtrack.dto.*;
import com.licenta.foodtrack.exception.ObiectivInvalidNutrientsException;
import com.licenta.foodtrack.mapper.MasuratoriMapper;
import com.licenta.foodtrack.mapper.ObiectivMapper;
import com.licenta.foodtrack.model.*;
import com.licenta.foodtrack.repository.*;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDate;
import java.util.*;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("MasuratoareService Unit Tests with Mockito")
class MasuratoareServiceTest {

    @Mock
    private MasuratoareGrasimeCorporalaRepository masuratoareGrasimeCorporalaRepository;

    @Mock
    private MasuratoareGreutateRepository masuratoareGreutateRepository;

    @Mock
    private MasuratoareInaltimeRepository masuratoareInaltimeRepository;

    @Mock
    private ObiectivRepository obiectivRepository;

    @Mock
    private UtilizatorRepository utilizatorRepository;

    @Mock
    private MasuratoriMapper masuratoriMapper;

    @Mock
    private ObiectivMapper obiectivMapper;

    @InjectMocks
    private MasuratoareService masuratoareService;

    private UUID userId;
    private LocalDate testDate;

    @BeforeEach
    void setUp() {
        userId = UUID.randomUUID();
        testDate = LocalDate.now();
    }

    @Test
    @DisplayName("getMasuratoriGreutate should return user weight measurements")
    void getMasuratoriGreutate_shouldReturnMeasurements() {
        // Arrange
        MasuratoareGreutate masurare1 = new MasuratoareGreutate();
        masurare1.setGreutateKg(75.5);
        masurare1.setDate(testDate);

        MasuratoareGreutate masurare2 = new MasuratoareGreutate();
        masurare2.setGreutateKg(74.8);
        masurare2.setDate(testDate.minusDays(1));

        List<MasuratoareGreutate> measurements = Arrays.asList(masurare1, masurare2);

        when(masuratoareGreutateRepository.findByUtilizatorId(userId))
                .thenReturn(measurements);

        // Act
        List<MasuratoareGreutateDto> result = masuratoareService.getMasuratoriGreutate(userId);

        // Assert
        assertEquals(2, result.size());
        verify(masuratoareGreutateRepository).findByUtilizatorId(userId);
    }

    @Test
    @DisplayName("getMasuratoriGreutate should return empty list when no measurements")
    void getMasuratoriGreutate_shouldReturnEmptyList() {
        // Arrange
        when(masuratoareGreutateRepository.findByUtilizatorId(userId))
                .thenReturn(Collections.emptyList());

        // Act
        List<MasuratoareGreutateDto> result = masuratoareService.getMasuratoriGreutate(userId);

        // Assert
        assertTrue(result.isEmpty());
        verify(masuratoareGreutateRepository).findByUtilizatorId(userId);
    }

    @Test
    @DisplayName("getMasuratoriInaltime should return user height measurements")
    void getMasuratoriInaltime_shouldReturnMeasurements() {
        // Arrange
        MasuratoareInaltime masurare1 = new MasuratoareInaltime();
        masurare1.setInaltimeCm(175.0);
        masurare1.setDate(testDate);

        List<MasuratoareInaltime> measurements = List.of(masurare1);

        when(masuratoareInaltimeRepository.findByUtilizatorId(userId))
                .thenReturn(measurements);

        // Act
        List<MasuratoareInaltimeDto> result = masuratoareService.getMasuratoriInaltime(userId);

        // Assert
        assertEquals(1, result.size());
        verify(masuratoareInaltimeRepository).findByUtilizatorId(userId);
    }

    @Test
    @DisplayName("getMasuratoriGrasimeCorporala should return user body fat measurements")
    void getMasuratoriGrasimeCorporala_shouldReturnMeasurements() {
        // Arrange
        MasuratoareGrasimeCorporala masurare1 = new MasuratoareGrasimeCorporala();
        masurare1.setGrasimeCorporalaProcent(20.5);
        masurare1.setDate(testDate);

        List<MasuratoareGrasimeCorporala> measurements = List.of(masurare1);

        when(masuratoareGrasimeCorporalaRepository.findByUtilizatorId(userId))
                .thenReturn(measurements);

        // Act
        List<MasuratoareGrasimeCorporalaDto> result = masuratoareService.getMasuratoriGrasimeCorporala(userId);

        // Assert
        assertEquals(1, result.size());
        verify(masuratoareGrasimeCorporalaRepository).findByUtilizatorId(userId);
    }

    @Test
    @DisplayName("adaugaMasuratoareGreutate should create or update weight measurement")
    void adaugaMasuratoareGreutate_shouldCreateMeasurement() {
        // Arrange
        MasuratoareGreutateDto dto = new MasuratoareGreutateDto(75.5, testDate);
        MasuratoareGreutate masurare = new MasuratoareGreutate();
        Utilizator user = new Utilizator();
        user.setId(userId);

        MasuratoareGreutateResponse response = mock(MasuratoareGreutateResponse.class);

        when(masuratoareGreutateRepository.findByUtilizatorIdAndDate(userId, testDate))
                .thenReturn(Optional.empty());
        when(masuratoriMapper.toMasuratoareGreutate(dto)).thenReturn(masurare);
        when(utilizatorRepository.getReferenceById(userId)).thenReturn(user);
        when(masuratoareGreutateRepository.save(masurare)).thenReturn(masurare);
        when(masuratoriMapper.toMasuratoareGreutateResponse(masurare)).thenReturn(response);

        // Act
        MasuratoareGreutateResponse result = masuratoareService.adaugaMasuratoareGreutate(dto, userId);

        // Assert
        assertNotNull(result);
        verify(masuratoareGreutateRepository).findByUtilizatorIdAndDate(userId, testDate);
        verify(masuratoareGreutateRepository).save(masurare);
    }

    @Test
    @DisplayName("adaugaMasuratoareGreutate should update existing measurement")
    void adaugaMasuratoareGreutate_shouldUpdateExistingMeasurement() {
        // Arrange
        MasuratoareGreutateDto dto = new MasuratoareGreutateDto(75.5, testDate);
        MasuratoareGreutate existingMasurare = new MasuratoareGreutate();
        existingMasurare.setGreutateKg(74.0);

        Utilizator user = new Utilizator();
        user.setId(userId);

        MasuratoareGreutateResponse response = mock(MasuratoareGreutateResponse.class);

        when(masuratoareGreutateRepository.findByUtilizatorIdAndDate(userId, testDate))
                .thenReturn(Optional.of(existingMasurare));
        when(utilizatorRepository.getReferenceById(userId)).thenReturn(user);
        when(masuratoareGreutateRepository.save(existingMasurare)).thenReturn(existingMasurare);
        when(masuratoriMapper.toMasuratoareGreutateResponse(existingMasurare)).thenReturn(response);

        // Act
        MasuratoareGreutateResponse result = masuratoareService.adaugaMasuratoareGreutate(dto, userId);

        // Assert
        assertNotNull(result);
        assertEquals(75.5, existingMasurare.getGreutateKg());
        verify(masuratoareGreutateRepository).save(existingMasurare);
    }

    @Test
    @DisplayName("adaugaMasuratoareInaltime should create or update height measurement")
    void adaugaMasuratoareInaltime_shouldCreateMeasurement() {
        // Arrange
        MasuratoareInaltimeDto dto = new MasuratoareInaltimeDto(175.0, testDate);
        MasuratoareInaltime masurare = new MasuratoareInaltime();
        Utilizator user = new Utilizator();
        user.setId(userId);

        MasuratoareInaltimeResponse response = mock(MasuratoareInaltimeResponse.class);

        when(masuratoareInaltimeRepository.findByUtilizatorIdAndDate(userId, testDate))
                .thenReturn(Optional.empty());
        when(masuratoriMapper.toMasuratoareInaltime(dto)).thenReturn(masurare);
        when(utilizatorRepository.getReferenceById(userId)).thenReturn(user);
        when(masuratoareInaltimeRepository.save(masurare)).thenReturn(masurare);
        when(masuratoriMapper.toMasuratoareInaltimeResponse(masurare)).thenReturn(response);

        // Act
        MasuratoareInaltimeResponse result = masuratoareService.adaugaMasuratoareInaltime(dto, userId);

        // Assert
        assertNotNull(result);
        verify(masuratoareInaltimeRepository).save(masurare);
    }

    @Test
    @DisplayName("adaugaMasuratoareGrasimeCorporala should create body fat measurement")
    void adaugaMasuratoareGrasimeCorporala_shouldCreateMeasurement() {
        // Arrange
        MasuratoareGrasimeCorporalaDto dto = new MasuratoareGrasimeCorporalaDto(20.5, testDate);
        MasuratoareGrasimeCorporala masurare = new MasuratoareGrasimeCorporala();
        Utilizator user = new Utilizator();
        user.setId(userId);

        MasuratoareGrasimeCorporalaResponse response = mock(MasuratoareGrasimeCorporalaResponse.class);

        when(masuratoareGrasimeCorporalaRepository.findByUtilizatorIdAndDate(userId, testDate))
                .thenReturn(Optional.empty());
        when(masuratoriMapper.toMasuratoareGrasimeCorporala(dto)).thenReturn(masurare);
        when(utilizatorRepository.getReferenceById(userId)).thenReturn(user);
        when(masuratoareGrasimeCorporalaRepository.save(masurare)).thenReturn(masurare);
        when(masuratoriMapper.toMasuratoareGrasimeCorporalaResponse(masurare)).thenReturn(response);

        // Act
        MasuratoareGrasimeCorporalaResponse result =
                masuratoareService.adaugaMasuratoareGrasimeCorporala(dto, userId);

        // Assert
        assertNotNull(result);
        verify(masuratoareGrasimeCorporalaRepository).save(masurare);
    }

    @Test
    @DisplayName("adaugaObiectiv should create objective with valid nutrients")
    void adaugaObiectiv_shouldCreateObjective() {
        // Arrange
        ObiectivDto dto = new ObiectivDto(
                testDate,
                2000.0,    // calories
                160.0,     // protein
                250.0,     // carbs
                67.0       // fat
        );

        Obiectiv obiectiv = mock(Obiectiv.class);  // ← MOCK
        obiectiv.setCalories(2000.0);
        obiectiv.setProtein(160.0);
        obiectiv.setCarbohydrates(250.0);
        obiectiv.setFat(67.0);
        obiectiv.setDataStart(testDate);

        Utilizator user = new Utilizator();
        user.setId(userId);

        ObiectivDto resultDto = mock(ObiectivDto.class);

        when(obiectivRepository.findByUtilizatorIdAndDataStart(userId, testDate))
                .thenReturn(Optional.empty());
        when(obiectivMapper.toObiectiv(dto)).thenReturn(obiectiv);
        when(utilizatorRepository.getReferenceById(userId)).thenReturn(user);
        when(obiectiv.nutrientsAreValid()).thenReturn(true);
        when(obiectivRepository.save(obiectiv)).thenReturn(obiectiv);
        when(obiectivMapper.toObiectivDto(obiectiv)).thenReturn(resultDto);

        // Act
        ObiectivDto result = masuratoareService.adaugaObiectiv(dto, userId);

        // Assert
        assertNotNull(result);
        verify(obiectivRepository).save(obiectiv);
    }

    @Test
    @DisplayName("adaugaObiectiv should throw when nutrients are invalid")
    void adaugaObiectiv_shouldThrowWhenNutrientsInvalid() {
        // Arrange
        ObiectivDto dto = new ObiectivDto(
                testDate,
                2000.0,
                160.0,
                250.0,
                100.0
        );

        Obiectiv obiectiv = mock(Obiectiv.class);  // ← MOCK
        obiectiv.setCalories(2000.0);
        obiectiv.setProtein(160.0);
        obiectiv.setCarbohydrates(250.0);
        obiectiv.setFat(100.0);

        Utilizator user = new Utilizator();
        user.setId(userId);

        when(obiectivRepository.findByUtilizatorIdAndDataStart(userId, testDate))
                .thenReturn(Optional.empty());
        when(obiectivMapper.toObiectiv(dto)).thenReturn(obiectiv);
        when(utilizatorRepository.getReferenceById(userId)).thenReturn(user);
        when(obiectiv.nutrientsAreValid()).thenReturn(false);

        // Act & Assert
        assertThrows(ObiectivInvalidNutrientsException.class, () -> {
            masuratoareService.adaugaObiectiv(dto, userId);
        });
    }
    @Test
    @DisplayName("calculeazaObiectiv should calculate objective based on TDEE percentage")
    void calculeazaObiectiv_shouldCalculateObjective() {
        // Arrange
        Utilizator user = mock(Utilizator.class);
        user.setId(userId);


        when(utilizatorRepository.findById(userId)).thenReturn(Optional.of(user));
        when(user.calculateTdee(LocalDate.now())).thenReturn(2500.0);

        // Act
        ObiectivCalculatResponse result = masuratoareService.calculeazaObiectiv(0.9, userId);

        // Assert
        assertNotNull(result);
        assertEquals(112.5, result.protein());      // (2500 * 0.9 * 0.2 / 4)
        assertEquals(281.25, result.carbohydrates()); // (2500 * 0.9 * 0.5 / 4)
        assertEquals(75.0, result.fat());            // (2500 * 0.9 * 0.3 / 9)
    }

    @Test
    @DisplayName("calculeazaObiectiv should throw when user not found")
    void calculeazaObiectiv_shouldThrowWhenUserNotFound() {
        // Arrange
        when(utilizatorRepository.findById(userId)).thenReturn(Optional.empty());

        // Act & Assert
        assertThrows(RuntimeException.class, () -> {
            masuratoareService.calculeazaObiectiv(0.9, userId);
        });
    }
}