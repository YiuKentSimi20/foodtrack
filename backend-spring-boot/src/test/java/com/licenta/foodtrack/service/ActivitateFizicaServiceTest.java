package com.licenta.foodtrack.service;

import com.licenta.foodtrack.dto.*;
import com.licenta.foodtrack.mapper.ActivitateFizicaMapper;
import com.licenta.foodtrack.mapper.InregistrareActivitateFizicaMapper;
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
@DisplayName("ActivitateFizicaService Unit Tests with Mockito")
class ActivitateFizicaServiceTest {

    @Mock
    private ActivitateFizicaRepository activitateFizicaRepository;

    @Mock
    private InregistrareActivitateFizicaRepository inregistrareActivitateFizicaRepository;

    @Mock
    private InregistrareActivitateFizicaMapper inregistrareActivitateFizicaMapper;

    @Mock
    private UtilizatorRepository utilizatorRepository;

    @Mock
    private ActivitateFizicaMapper activitateFizicaMapper;

    @InjectMocks
    private ActivitateFizicaService activitateFizicaService;

    private UUID userId;
    private LocalDate testDate;
    private Long activitateId;
    private Long inregistrareId;

    @BeforeEach
    void setUp() {
        userId = UUID.randomUUID();
        testDate = LocalDate.now();
        activitateId = 1L;
        inregistrareId = 1L;
    }

    @Test
    @DisplayName("getActivitatiFizice should return all physical activities")
    void getActivitatiFizice_shouldReturnAllActivities() {
        // Arrange
        ActivitateFizica activitate1 = new ActivitateFizica();
        activitate1.setId(1L);
        activitate1.setNume("Running");

        ActivitateFizica activitate2 = new ActivitateFizica();
        activitate2.setId(2L);
        activitate2.setNume("Swimming");

        List<ActivitateFizica> activities = Arrays.asList(activitate1, activitate2);

        ActivitateFizicaDto dto1 = mock(ActivitateFizicaDto.class);
        ActivitateFizicaDto dto2 = mock(ActivitateFizicaDto.class);

        when(activitateFizicaRepository.findAll()).thenReturn(activities);
        when(activitateFizicaMapper.toDto(activitate1)).thenReturn(dto1);
        when(activitateFizicaMapper.toDto(activitate2)).thenReturn(dto2);

        // Act
        List<ActivitateFizicaDto> result = activitateFizicaService.getActivitatiFizice(userId);

        // Assert
        assertEquals(2, result.size());
        verify(activitateFizicaRepository).findAll();
        verify(activitateFizicaMapper, times(2)).toDto(any(ActivitateFizica.class));
    }

    @Test
    @DisplayName("getActivitatiFizice should return empty list when no activities")
    void getActivitatiFizice_shouldReturnEmptyList() {
        // Arrange
        when(activitateFizicaRepository.findAll()).thenReturn(Collections.emptyList());

        // Act
        List<ActivitateFizicaDto> result = activitateFizicaService.getActivitatiFizice(userId);

        // Assert
        assertTrue(result.isEmpty());
        verify(activitateFizicaRepository).findAll();
    }

    @Test
    @DisplayName("adaugaInregistrareActivitateFizica should create physical activity registration")
    void adaugaInregistrareActivitateFizica_shouldCreateRegistration() {
        // Arrange
        InregistrareActivitateFizicaRequest request = new InregistrareActivitateFizicaRequest(
                activitateId,
                testDate,
                60.0,      // duration in minutes
                null     // notes
        );

        Utilizator user = mock(Utilizator.class);
        user.setId(userId);

        ActivitateFizica activitate = new ActivitateFizica();
        activitate.setId(activitateId);
        activitate.setMet(7.0);

        InregistrareActivitateFizica inregistrare = new InregistrareActivitateFizica();
        InregistrareActivitateFizicaResponse response = mock(InregistrareActivitateFizicaResponse.class);

        when(utilizatorRepository.findById(userId)).thenReturn(Optional.of(user));
        when(activitateFizicaRepository.findById(activitateId)).thenReturn(Optional.of(activitate));
        when(inregistrareActivitateFizicaMapper.toInregistrareActivitateFizica(activitate, request))
                .thenReturn(inregistrare);
        when(user.getMasuratoareGreutateFor(testDate)).thenReturn(Optional.of(75.0));
        when(inregistrareActivitateFizicaRepository.save(inregistrare)).thenReturn(inregistrare);
        when(inregistrareActivitateFizicaMapper.toResponse(inregistrare)).thenReturn(response);

        // Act
        InregistrareActivitateFizicaResponse result =
                activitateFizicaService.adaugaInregistrareActivitateFizica(request, userId);

        // Assert
        assertNotNull(result);
        assertEquals(SursaDate.MANUAL, inregistrare.getSursaDate());
        verify(utilizatorRepository).findById(userId);
        verify(activitateFizicaRepository).findById(activitateId);
        verify(inregistrareActivitateFizicaRepository).save(inregistrare);
    }

    @Test
    @DisplayName("adaugaInregistrareActivitateFizica should throw when user not found")
    void adaugaInregistrareActivitateFizica_shouldThrowWhenUserNotFound() {
        // Arrange
        InregistrareActivitateFizicaRequest request = new InregistrareActivitateFizicaRequest(
                activitateId, testDate, 60.0, null
        );

        when(utilizatorRepository.findById(userId)).thenReturn(Optional.empty());

        // Act & Assert
        assertThrows(IllegalStateException.class, () -> {
            activitateFizicaService.adaugaInregistrareActivitateFizica(request, userId);
        });
    }

    @Test
    @DisplayName("adaugaInregistrareActivitateFizica should throw when activity not found")
    void adaugaInregistrareActivitateFizica_shouldThrowWhenActivityNotFound() {
        // Arrange
        InregistrareActivitateFizicaRequest request = new InregistrareActivitateFizicaRequest(
                activitateId, testDate, 60.0, null
        );

        Utilizator user = new Utilizator();
        user.setId(userId);

        when(utilizatorRepository.findById(userId)).thenReturn(Optional.of(user));
        when(activitateFizicaRepository.findById(activitateId)).thenReturn(Optional.empty());

        // Act & Assert
        assertThrows(IllegalStateException.class, () -> {
            activitateFizicaService.adaugaInregistrareActivitateFizica(request, userId);
        });
    }

    @Test
    @DisplayName("modificaInregistrareActivitateFizica should update activity registration")
    void modificaInregistrareActivitateFizica_shouldUpdateRegistration() {
        // Arrange
        ModificaInregistrareActivitateFizicaRequest request =
                new ModificaInregistrareActivitateFizicaRequest(inregistrareId, 90.0, "Updated notes");

        Utilizator user = mock(Utilizator.class);
        when(user.getId()).thenReturn(userId);  // ← SET ID EXPLICITLY

        InregistrareActivitateFizica inregistrare = new InregistrareActivitateFizica();
        inregistrare.setId(inregistrareId);
        inregistrare.setMet(7.0);
        inregistrare.setDataActivitate(testDate);
        inregistrare.setDurataMin(60.0);

        InregistrareActivitateFizicaResponse response = mock(InregistrareActivitateFizicaResponse.class);

        when(utilizatorRepository.findById(userId)).thenReturn(Optional.of(user));
        when(inregistrareActivitateFizicaRepository
                .findByIdAndUtilizatorIdAndSursaDate(inregistrareId, userId, SursaDate.MANUAL))
                .thenReturn(Optional.of(inregistrare));
        when(user.getMasuratoareGreutateFor(testDate)).thenReturn(Optional.of(75.0));
        when(inregistrareActivitateFizicaRepository.save(inregistrare)).thenReturn(inregistrare);
        when(inregistrareActivitateFizicaMapper.toResponse(inregistrare)).thenReturn(response);

        // Act
        InregistrareActivitateFizicaResponse result =
                activitateFizicaService.modificaInregistrareActivitateFizica(request, userId);

        // Assert
        assertNotNull(result);
        assertEquals(90, inregistrare.getDurataMin());
        assertEquals("Updated notes", inregistrare.getNotite());
        verify(inregistrareActivitateFizicaRepository).save(inregistrare);
    }

    @Test
    @DisplayName("modificaInregistrareActivitateFizica should throw when registration not found")
    void modificaInregistrareActivitateFizica_shouldThrowWhenNotFound() {
        // Arrange
        ModificaInregistrareActivitateFizicaRequest request =
                new ModificaInregistrareActivitateFizicaRequest(inregistrareId, 90.0, "notes");

        Utilizator user = mock(Utilizator.class);
        when(user.getId()).thenReturn(userId);  // ← SET ID EXPLICITLY

        when(utilizatorRepository.findById(userId)).thenReturn(Optional.of(user));
        when(inregistrareActivitateFizicaRepository
                .findByIdAndUtilizatorIdAndSursaDate(inregistrareId, userId, SursaDate.MANUAL))
                .thenReturn(Optional.empty());

        // Act & Assert
        assertThrows(IllegalStateException.class, () -> {
            activitateFizicaService.modificaInregistrareActivitateFizica(request, userId);
        });
    }

    @Test
    @DisplayName("stergeInregistrareActivitateFizica should delete registration")
    void stergeInregistrareActivitateFizica_shouldDeleteRegistration() {
        // Arrange
        InregistrareActivitateFizica inregistrare = new InregistrareActivitateFizica();
        inregistrare.setId(inregistrareId);

        when(inregistrareActivitateFizicaRepository
                .findByIdAndUtilizatorIdAndSursaDate(inregistrareId, userId, SursaDate.MANUAL))
                .thenReturn(Optional.of(inregistrare));

        // Act
        activitateFizicaService.stergeInregistrareActivitateFizica(inregistrareId, userId);

        // Assert
        verify(inregistrareActivitateFizicaRepository).delete(inregistrare);
    }

    @Test
    @DisplayName("stergeInregistrareActivitateFizica should throw when registration not found")
    void stergeInregistrareActivitateFizica_shouldThrowWhenNotFound() {
        // Arrange
        when(inregistrareActivitateFizicaRepository
                .findByIdAndUtilizatorIdAndSursaDate(inregistrareId, userId, SursaDate.MANUAL))
                .thenReturn(Optional.empty());

        // Act & Assert
        assertThrows(IllegalStateException.class, () -> {
            activitateFizicaService.stergeInregistrareActivitateFizica(inregistrareId, userId);
        });
    }

    @Test
    @DisplayName("adaugaInregistrareHealthConnect should create HealthConnect records")
    void adaugaInregistrareHealthConnect_shouldCreateRecords() {
        // Arrange
        HealthConnectRequest request1 = new HealthConnectRequest(testDate, 500, 8000.0);
        HealthConnectRequest request2 = new HealthConnectRequest(testDate.minusDays(1), 450, 7500.0);
        List<HealthConnectRequest> requests = Arrays.asList(request1, request2);

        Utilizator user = new Utilizator();
        user.setId(userId);

        InregistrareActivitateFizica inregistrare1 = new InregistrareActivitateFizica();
        InregistrareActivitateFizica inregistrare2 = new InregistrareActivitateFizica();

        InregistrareActivitateFizicaResponse response1 = mock(InregistrareActivitateFizicaResponse.class);
        InregistrareActivitateFizicaResponse response2 = mock(InregistrareActivitateFizicaResponse.class);

        when(utilizatorRepository.findById(userId)).thenReturn(Optional.of(user));
        when(inregistrareActivitateFizicaRepository
                .findFirstByUtilizatorIdAndSursaDateAndDataActivitate(userId, SursaDate.HEALTH_CONNECT, testDate))
                .thenReturn(Optional.empty());
        when(inregistrareActivitateFizicaRepository
                .findFirstByUtilizatorIdAndSursaDateAndDataActivitate(userId, SursaDate.HEALTH_CONNECT, testDate.minusDays(1)))
                .thenReturn(Optional.empty());
        when(inregistrareActivitateFizicaRepository.save(any(InregistrareActivitateFizica.class)))
                .thenReturn(inregistrare1, inregistrare2);
        when(inregistrareActivitateFizicaMapper.toResponse(inregistrare1)).thenReturn(response1);
        when(inregistrareActivitateFizicaMapper.toResponse(inregistrare2)).thenReturn(response2);

        // Act
        List<InregistrareActivitateFizicaResponse> result =
                activitateFizicaService.adaugaInregistrareHealthConnect(requests, userId);

        // Assert
        assertEquals(2, result.size());
        verify(utilizatorRepository).findById(userId);
        verify(inregistrareActivitateFizicaRepository, times(2)).save(any(InregistrareActivitateFizica.class));
    }

    @Test
    @DisplayName("adaugaInregistrareHealthConnect should throw when user not found")
    void adaugaInregistrareHealthConnect_shouldThrowWhenUserNotFound() {
        // Arrange
        HealthConnectRequest request = new HealthConnectRequest(testDate, 500, 8000.0);
        List<HealthConnectRequest> requests = List.of(request);

        when(utilizatorRepository.findById(userId)).thenReturn(Optional.empty());

        // Act & Assert
        assertThrows(IllegalStateException.class, () -> {
            activitateFizicaService.adaugaInregistrareHealthConnect(requests, userId);
        });
    }
}