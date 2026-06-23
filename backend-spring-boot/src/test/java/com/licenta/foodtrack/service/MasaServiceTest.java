package com.licenta.foodtrack.service;

import com.licenta.foodtrack.dto.*;
import com.licenta.foodtrack.exception.DataNotBelongingToUserException;
import com.licenta.foodtrack.mapper.*;
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
@DisplayName("MasaService Unit Tests with Mockito")
class MasaServiceTest {

    @Mock
    private MasaRepository masaRepository;

    @Mock
    private AlimentRepository alimentRepository;

    @Mock
    private InregistrareAlimentRepository inregistrareAlimentRepository;

    @Mock
    private UtilizatorRepository utilizatorRepository;

    @Mock
    private InregistrareAlimentMapper inregistrareAlimentMapper;

    @Mock
    private MasaMapper masaMapper;

    @Mock
    private CategorieMasaRepository categorieMasaRepository;

    @Mock
    private CategorieMasaMapper categorieMasaMapper;

    @Mock
    private InregistrareActivitateFizicaMapper inregistrareActivitateFizicaMapper;

    @InjectMocks
    private MasaService masaService;

    private UUID userId;
    private Long masaId;
    private Long alimentId;
    private Long categorieMasaId;

    @BeforeEach
    void setUp() {
        userId = UUID.randomUUID();
        masaId = 1L;
        alimentId = 1L;
        categorieMasaId = 1L;
    }

    @Test
    @DisplayName("getMasaById should return meal when it belongs to user")
    void getMasaById_shouldReturnMeal() {
        // Arrange
        Masa masa = new Masa();
        masa.setId(masaId);
        Utilizator user = new Utilizator();
        user.setId(userId);
        masa.setUtilizator(user);

        MasaResponse expectedResponse = mock(MasaResponse.class);

        when(masaRepository.findById(masaId)).thenReturn(Optional.of(masa));
        when(masaMapper.toResponse(masa)).thenReturn(expectedResponse);

        // Act
        MasaResponse result = masaService.getMasaById(masaId, userId);

        // Assert
        assertNotNull(result);
        assertEquals(expectedResponse, result);
        verify(masaRepository).findById(masaId);
        verify(masaMapper).toResponse(masa);
    }

    @Test
    @DisplayName("getMasaById should throw when meal doesn't belong to user")
    void getMasaById_shouldThrowWhenNotOwnedByUser() {
        // Arrange
        Masa masa = new Masa();
        masa.setId(masaId);
        Utilizator otherUser = new Utilizator();
        otherUser.setId(UUID.randomUUID());
        masa.setUtilizator(otherUser);

        when(masaRepository.findById(masaId)).thenReturn(Optional.of(masa));

        // Act & Assert
        assertThrows(IllegalStateException.class, () -> {
            masaService.getMasaById(masaId, userId);
        });
    }

    @Test
    @DisplayName("getMasaById should throw when meal not found")
    void getMasaById_shouldThrowWhenNotFound() {
        // Arrange
        when(masaRepository.findById(masaId)).thenReturn(Optional.empty());

        // Act & Assert
        assertThrows(IllegalStateException.class, () -> {
            masaService.getMasaById(masaId, userId);
        });
    }

    @Test
    @DisplayName("adaugaInregistrareAliment should create food registration")
    void adaugaInregistrareAliment_shouldCreateRegistration() {
        // Arrange
        LocalDate testDate = LocalDate.now();
        InregistrareAlimentRequest request = new InregistrareAlimentRequest(
                categorieMasaId, testDate, 150.0, alimentId
        );

        CategorieMasa categorieMasa = new CategorieMasa();
        categorieMasa.setId(categorieMasaId);
        Utilizator user = new Utilizator();
        user.setId(userId);
        categorieMasa.setUtilizator(user);

        Aliment aliment = new Aliment();
        aliment.setId(alimentId);

        Masa masa = new Masa();
        masa.setId(masaId);
        masa.setUtilizator(user);
        masa.setCategorieMasa(categorieMasa);

        InregistrareAliment inregistrareAliment = new InregistrareAliment();
        InregistrareAlimentResponse response = mock(InregistrareAlimentResponse.class);

        when(categorieMasaRepository.findById(categorieMasaId)).thenReturn(Optional.of(categorieMasa));
        when(masaRepository.existsByCategorieMasaIdAndDataMeseiAndUtilizatorId(
                categorieMasaId, testDate, userId)).thenReturn(false);
        when(utilizatorRepository.getReferenceById(userId)).thenReturn(user);
        when(masaRepository.save(any(Masa.class))).thenReturn(masa);
        when(alimentRepository.findById(alimentId)).thenReturn(Optional.of(aliment));
        when(inregistrareAlimentMapper.toInregistrareAliment(aliment, 150.0))
                .thenReturn(inregistrareAliment);
        when(masaRepository.findByCategorieMasaIdAndDataMeseiAndUtilizatorId(
                categorieMasaId, testDate, userId)).thenReturn(Optional.of(masa));
        when(inregistrareAlimentRepository.save(inregistrareAliment))
                .thenReturn(inregistrareAliment);
        when(inregistrareAlimentMapper.toResponse(inregistrareAliment))
                .thenReturn(response);

        // Act
        InregistrareAlimentResponse result = masaService.adaugaInregistrareAliment(request, userId);

        // Assert
        assertNotNull(result);
        assertEquals(response, result);
        verify(categorieMasaRepository).findById(categorieMasaId);
        verify(alimentRepository).findById(alimentId);
        verify(inregistrareAlimentRepository).save(inregistrareAliment);
    }

    @Test
    @DisplayName("adaugaInregistrareAliment should throw when category doesn't belong to user")
    void adaugaInregistrareAliment_shouldThrowWhenCategoryNotOwnedByUser() {
        // Arrange
        LocalDate testDate = LocalDate.now();
        InregistrareAlimentRequest request = new InregistrareAlimentRequest(
                categorieMasaId,testDate, 150.0, alimentId
        );

        CategorieMasa categorieMasa = new CategorieMasa();
        categorieMasa.setId(categorieMasaId);
        Utilizator otherUser = new Utilizator();
        otherUser.setId(UUID.randomUUID());
        categorieMasa.setUtilizator(otherUser);

        when(categorieMasaRepository.findById(categorieMasaId)).thenReturn(Optional.of(categorieMasa));

        // Act & Assert
        assertThrows(DataNotBelongingToUserException.class, () -> {
            masaService.adaugaInregistrareAliment(request, userId);
        });
    }

    @Test
    @DisplayName("getMese should return all user meals when no dates provided")
    void getMese_shouldReturnAllMeals() {
        // Arrange
        Masa masa1 = new Masa();
        Masa masa2 = new Masa();
        List<Masa> mese = Arrays.asList(masa1, masa2);

        MasaResponse response1 = mock(MasaResponse.class);
        MasaResponse response2 = mock(MasaResponse.class);

        when(masaRepository.findAllByUtilizatorId(userId)).thenReturn(mese);
        when(masaMapper.toResponse(masa1)).thenReturn(response1);
        when(masaMapper.toResponse(masa2)).thenReturn(response2);

        // Act
        List<MasaResponse> result = masaService.getMese(null, null, userId);

        // Assert
        assertEquals(2, result.size());
        verify(masaRepository).findAllByUtilizatorId(userId);
        verify(masaMapper, times(2)).toResponse(any(Masa.class));
    }

    @Test
    @DisplayName("getMese should return meals between dates")
    void getMese_shouldReturnMealsBetweenDates() {
        // Arrange
        LocalDate startDate = LocalDate.of(2026, 6, 1);
        LocalDate endDate = LocalDate.of(2026, 6, 30);

        Masa masa1 = new Masa();
        List<Masa> mese = List.of(masa1);

        MasaResponse response1 = mock(MasaResponse.class);

        when(masaRepository.findAllByUtilizatorIdAndDataMeseiBetween(userId, startDate, endDate))
                .thenReturn(mese);
        when(masaMapper.toResponse(masa1)).thenReturn(response1);

        // Act
        List<MasaResponse> result = masaService.getMese(startDate, endDate, userId);

        // Assert
        assertEquals(1, result.size());
        verify(masaRepository).findAllByUtilizatorIdAndDataMeseiBetween(userId, startDate, endDate);
    }

    @Test
    @DisplayName("modificaGramajInregistrareAliment should update gram quantity")
    void modificaGramajInregistrareAliment_shouldUpdateGrams() {
        // Arrange
        Long inregistrareId = 1L;
        Double newGrams = 200.0;
        ModificareGramajInregistrareAlimentRequest request =
                new ModificareGramajInregistrareAlimentRequest(inregistrareId, newGrams);

        InregistrareAliment inregistrare = new InregistrareAliment();
        Masa masa = new Masa();
        Utilizator user = new Utilizator();
        user.setId(userId);
        masa.setUtilizator(user);
        inregistrare.setMasa(masa);

        InregistrareAlimentResponse response = mock(InregistrareAlimentResponse.class);

        when(inregistrareAlimentRepository.findById(inregistrareId))
                .thenReturn(Optional.of(inregistrare));
        when(inregistrareAlimentRepository.save(inregistrare))
                .thenReturn(inregistrare);
        when(inregistrareAlimentMapper.toResponse(inregistrare))
                .thenReturn(response);

        // Act
        InregistrareAlimentResponse result =
                masaService.modificaGramajInregistrareAliment(request, userId);

        // Assert
        assertNotNull(result);
        assertEquals(newGrams, inregistrare.getGrams());
        verify(inregistrareAlimentRepository).save(inregistrare);
    }

    @Test
    @DisplayName("modificaGramajInregistrareAliment should throw when not owned by user")
    void modificaGramajInregistrareAliment_shouldThrowWhenNotOwnedByUser() {
        // Arrange
        Long inregistrareId = 1L;
        ModificareGramajInregistrareAlimentRequest request =
                new ModificareGramajInregistrareAlimentRequest(inregistrareId, 200.0);

        InregistrareAliment inregistrare = new InregistrareAliment();
        Masa masa = new Masa();
        Utilizator otherUser = new Utilizator();
        otherUser.setId(UUID.randomUUID());
        masa.setUtilizator(otherUser);
        inregistrare.setMasa(masa);

        when(inregistrareAlimentRepository.findById(inregistrareId))
                .thenReturn(Optional.of(inregistrare));

        // Act & Assert
        assertThrows(DataNotBelongingToUserException.class, () -> {
            masaService.modificaGramajInregistrareAliment(request, userId);
        });
    }

    @Test
    @DisplayName("stergeInregistrareAliment should delete registration")
    void stergeInregistrareAliment_shouldDeleteRegistration() {
        // Arrange
        Long inregistrareId = 1L;

        InregistrareAliment inregistrare = new InregistrareAliment();
        Masa masa = new Masa();
        Utilizator user = new Utilizator();
        user.setId(userId);
        masa.setUtilizator(user);
        inregistrare.setMasa(masa);

        when(inregistrareAlimentRepository.findById(inregistrareId))
                .thenReturn(Optional.of(inregistrare));

        // Act
        masaService.stergeInregistrareAliment(inregistrareId, userId);

        // Assert
        verify(inregistrareAlimentRepository).deleteById(inregistrareId);
    }

    @Test
    @DisplayName("getCategoriiMese should return user's meal categories")
    void getCategoriiMese_shouldReturnCategories() {
        // Arrange
        CategorieMasa cat1 = new CategorieMasa();
        CategorieMasa cat2 = new CategorieMasa();
        List<CategorieMasa> categories = Arrays.asList(cat1, cat2);

        CategorieMasaDto dto1 = mock(CategorieMasaDto.class);
        CategorieMasaDto dto2 = mock(CategorieMasaDto.class);

        when(categorieMasaRepository.findAllByUtilizatorIdOrderByNumarOrdine(userId))
                .thenReturn(categories);
        when(categorieMasaMapper.toDto(cat1)).thenReturn(dto1);
        when(categorieMasaMapper.toDto(cat2)).thenReturn(dto2);

        // Act
        List<CategorieMasaDto> result = masaService.getCategoriiMese(userId);

        // Assert
        assertEquals(2, result.size());
        verify(categorieMasaRepository).findAllByUtilizatorIdOrderByNumarOrdine(userId);
        verify(categorieMasaMapper, times(2)).toDto(any(CategorieMasa.class));
    }
}