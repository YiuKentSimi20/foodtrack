package com.licenta.foodtrack.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.licenta.foodtrack.auth.AuthenticationRequest;
import com.licenta.foodtrack.auth.AuthenticationResponse;
import com.licenta.foodtrack.dto.CreateAlimentRequest;
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

import java.time.LocalDate;
import java.util.UUID;

import static org.hamcrest.Matchers.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@AutoConfigureMockMvc
@Transactional
@ActiveProfiles("test")
@DisplayName("Aliment Controller Integration Tests")
class AlimentControllerIntegrationTest {

    @Autowired
    private MockMvc mockMvc;

    private final ObjectMapper objectMapper = new ObjectMapper();

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
        user.setUsername("testuser");
        user.setEmail("test@example.com");
        user.setPassword(passwordEncoder.encode("Password123!"));
        user.setDataNasterii(LocalDate.of(1990, 5, 15));
        user.setGen(GenUtilizator.M);

        Utilizator saved = utilizatorRepository.save(user);
        userId = saved.getId();

        // Login to get token
        AuthenticationRequest loginRequest = new AuthenticationRequest("testuser", "Password123!");
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
    @DisplayName("POST /aliment should create custom food")
    void addAliment_shouldCreateCustomFood() throws Exception {
        CreateAlimentRequest request = new CreateAlimentRequest(
                "Grilled Chicken", "Homemade", null, 165.0, 31.0, 3.6, 0.0,
                1.3, 0.0, 0.0, 0.07, null, null
        );

        mockMvc.perform(post("/foodtrack/aliment")
                        .header("Authorization", "Bearer " + token)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.product_name", equalTo("Grilled Chicken")))
                .andExpect(jsonPath("$.data.is_validated", equalTo(false)));
    }

    @Test
    @DisplayName("GET /aliment/search should return matching foods")
    void searchByName_shouldReturnMatches() throws Exception {
        mockMvc.perform(get("/foodtrack/aliment/search-by-name")
                        .param("name", "apple")
                        .header("Authorization", "Bearer " + token)
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", hasSize(greaterThanOrEqualTo(0))));
    }

    @Test
    @DisplayName("GET /aliment/barcode should return 404 for invalid barcode")
    void searchByBarcode_shouldReturn404() throws Exception {
        mockMvc.perform(get("/foodtrack/aliment/barcode/INVALID123")
                        .header("Authorization", "Bearer " + token)
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isNotFound());
    }

    @Test
    @DisplayName("POST /aliment without auth should return 403")
    void addAliment_withoutAuth_shouldReturn403() throws Exception {
        CreateAlimentRequest request = new CreateAlimentRequest(
                "Chicken", "Brand", "CODE001", 165.0, 31.0, 3.6, 0.0,
                1.3, 0.0, 0.0, 0.07, null, null
        );

        mockMvc.perform(post("/foodtrack/aliment")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isForbidden());
    }
}