package com.licenta.foodtrack.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.licenta.foodtrack.auth.AuthenticationRequest;
import com.licenta.foodtrack.auth.AuthenticationResponse;
import com.licenta.foodtrack.dto.*;
import com.licenta.foodtrack.model.MasuratoareGreutate;
import com.licenta.foodtrack.model.Utilizator;
import com.licenta.foodtrack.model.GenUtilizator;
import com.licenta.foodtrack.repository.UtilizatorRepository;
import jakarta.transaction.Transactional;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.webmvc.test.autoconfigure.AutoConfigureMockMvc;
import org.springframework.http.MediaType;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.UUID;

import static org.hamcrest.Matchers.*;
import static org.mockito.Mockito.mock;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@AutoConfigureMockMvc
@Transactional
@ActiveProfiles("test")
@DisplayName("MasuratoareController Integration Tests")
class MasuratoareControllerIntegrationTest {

    @Autowired
    private MockMvc mockMvc;

    private final ObjectMapper objectMapper = new ObjectMapper().registerModule(new JavaTimeModule()).disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);


    @Autowired
    private UtilizatorRepository utilizatorRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    private String token;
    private UUID userId;

    @BeforeEach
    void setUp() throws Exception {
        utilizatorRepository.deleteAll();

        // Create test user
        Utilizator user = new Utilizator();
        user.setUsername("testuser_" + System.currentTimeMillis());
        user.setEmail("test_" + System.currentTimeMillis() + "@example.com");
        user.setPassword(passwordEncoder.encode("Password123!"));
        user.setDataNasterii(LocalDate.of(1990, 5, 15));
        user.setGen(GenUtilizator.M);

        // Initialize collections
        user.setMasuratoriGreutate(new ArrayList<>());
        user.setMasuratoriInaltime(new ArrayList<>());
        user.setMasuratoriGrasimeCorporala(new ArrayList<>());

        Utilizator saved = utilizatorRepository.save(user);
        userId = saved.getId();

        // Login to get token
        AuthenticationRequest loginRequest = new AuthenticationRequest(
                user.getUsername(), "Password123!"
        );
        MvcResult result = mockMvc.perform(post("/foodtrack/auth/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(loginRequest)))
                .andExpect(status().isOk())
                .andReturn();

        String response = result.getResponse().getContentAsString();
        AuthenticationResponse authResponse = objectMapper.readValue(response, AuthenticationResponse.class);
        token = authResponse.getToken();
    }

    @Test
    @DisplayName("GET /masuratoare/masuratori-greutate should return empty list")
    void getMasuratoriGreutate_shouldReturnEmptyList() throws Exception {
        mockMvc.perform(get("/foodtrack/masuratoare/masuratori-greutate")
                        .header("Authorization", "Bearer " + token)
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", instanceOf(java.util.List.class)))
                .andExpect(jsonPath("$", hasSize(0)));
    }

    @Test
    @DisplayName("GET /masuratoare/masuratori-intaltime should return empty list")
    void getMasuratoriInaltime_shouldReturnEmptyList() throws Exception {
        mockMvc.perform(get("/foodtrack/masuratoare/masuratori-intaltime")
                        .header("Authorization", "Bearer " + token)
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", instanceOf(java.util.List.class)))
                .andExpect(jsonPath("$", hasSize(0)));
    }

    @Test
    @DisplayName("GET /masuratoare/masuratori-grasime-corporala should return empty list")
    void getMasuratoriGrasimeCorporala_shouldReturnEmptyList() throws Exception {
        mockMvc.perform(get("/foodtrack/masuratoare/masuratori-grasime-corporala")
                        .header("Authorization", "Bearer " + token)
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", instanceOf(java.util.List.class)))
                .andExpect(jsonPath("$", hasSize(0)));
    }

    @Test
    @DisplayName("POST /masuratoare/greutate should add weight measurement")
    void adaugaMasuratoareGreutate_shouldAddMeasurement() throws Exception {
        MasuratoareGreutateDto request = new MasuratoareGreutateDto(
                80.0, LocalDate.of(2020, 5, 15)
        );
        mockMvc.perform(post("/foodtrack/masuratoare/greutate")
                        .header("Authorization", "Bearer " + token)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.status", equalTo(200)));
    }

    @Test
    @DisplayName("POST /masuratoare/inaltime should add height measurement")
    void adaugaMasuratoareInaltime_shouldAddMeasurement() throws Exception {
        MasuratoareInaltimeDto request = new MasuratoareInaltimeDto(
                180.0, LocalDate.of(2020, 5, 15)
        );
        mockMvc.perform(post("/foodtrack/masuratoare/inaltime")
                        .header("Authorization", "Bearer " + token)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.status", equalTo(200)));

    }

    @Test
    @DisplayName("POST /masuratoare/grasime-corporala should add body fat measurement")
    void adaugaMasuratoareGrasimeCorporala_shouldAddMeasurement() throws Exception {
        MasuratoareGrasimeCorporalaDto request = new MasuratoareGrasimeCorporalaDto(
                17.0, LocalDate.of(2020, 5, 15)
        );

        mockMvc.perform(post("/foodtrack/masuratoare/grasime-corporala")
                        .header("Authorization", "Bearer " + token)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.status", equalTo(200)));
    }

    @Test
    @DisplayName("GET /masuratoare/obiective should return empty list")
    void getObiective_shouldReturnEmptyList() throws Exception {
        mockMvc.perform(get("/foodtrack/masuratoare/obiective")
                        .header("Authorization", "Bearer " + token)
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", instanceOf(java.util.List.class)));
    }

    @Test
    @DisplayName("POST /masuratoare/obiective should add objective")
    void adaugaObiectiv_shouldAddObjective() throws Exception {
        ObiectivDto request = new ObiectivDto(
                LocalDate.of(2020, 5, 15),
                1700.0,
                100.0,
                100.0,
                100.0
        );

        mockMvc.perform(post("/foodtrack/masuratoare/obiective")
                        .header("Authorization", "Bearer " + token)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.status", equalTo(200)))
                .andExpect(jsonPath("$.message", containsString("adăugat cu succes")));
    }

    @Test
    @DisplayName("POST /masuratoare/obiective with invalid nutrients should return 400")
    void adaugaObiectiveWithInvalidNutrients_shouldReturn400() throws Exception {
        ObiectivDto request = new ObiectivDto(
                LocalDate.of(2020, 5, 15),
                1800.0,
                100.0,
                100.0,
                100.0
        );

        mockMvc.perform(post("/foodtrack/masuratoare/obiective")
                        .header("Authorization", "Bearer " + token)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.status", equalTo(400)))
                .andExpect(jsonPath("$.error", equalTo("VALIDATION_ERROR")));
    }

    @Test
    @DisplayName("GET /masuratoare/obiective/calculeaza should calculate objective")
    void calculeazaObiectiv_shouldReturnCalculatedValues() throws Exception {
        mockMvc.perform(get("/foodtrack/masuratoare/obiective/calculeaza")
                        .param("tdeeCaloriesPercentage", "0.9")
                        .header("Authorization", "Bearer " + token)
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", notNullValue()));
    }

    @Test
    @DisplayName("GET /masuratoare endpoints without auth should return 403")
    void getMasuratoare_withoutAuth_shouldReturn403() throws Exception {
        mockMvc.perform(get("/foodtrack/masuratoare/masuratori-greutate")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isForbidden());
    }

    @Test
    @DisplayName("POST /masuratoare/greutate with invalid data should return 400")
    void adaugaMasuratoareGreutate_invalidData_shouldReturn400() throws Exception {
        String invalidRequest = "{}";

        mockMvc.perform(post("/foodtrack/masuratoare/greutate")
                        .header("Authorization", "Bearer " + token)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(invalidRequest))
                .andExpect(status().isBadRequest());
    }

    @Test
    @DisplayName("GET /masuratoare/obiective/calculeaza with missing parameter should return 400")
    void calculeazaObiectiv_missingParameter_shouldReturn400() throws Exception {
        mockMvc.perform(get("/foodtrack/masuratoare/obiective/calculeaza")
                        .header("Authorization", "Bearer " + token)
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isBadRequest());
    }
}