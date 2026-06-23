package com.licenta.foodtrack.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.licenta.foodtrack.auth.AuthenticationRequest;
import com.licenta.foodtrack.auth.AuthenticationResponse;
import com.licenta.foodtrack.dto.CreateAlimentRequest;
import com.licenta.foodtrack.dto.ModificaDatePersonaleRequest;
import com.licenta.foodtrack.model.*;
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
@DisplayName("UtilizatorController Integration Tests")
class UtilizatorControllerIntegrationTest {

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
        user.setUsername("testuser_" + System.currentTimeMillis());
        user.setEmail("test_" + System.currentTimeMillis() + "@example.com");
        user.setPassword(passwordEncoder.encode("Password123!"));
        user.setDataNasterii(LocalDate.of(1990, 5, 15));
        user.setGen(GenUtilizator.M);

        // Initialize collections to avoid NPE
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
    @DisplayName("GET /utilizator/date-personale should return user personal data")
    void getDatePersonale_shouldReturnUserData() throws Exception {
        mockMvc.perform(get("/foodtrack/utilizator/date-personale")
                        .header("Authorization", "Bearer " + token)
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.username", notNullValue()))
                .andExpect(jsonPath("$.email", notNullValue()))
                .andExpect(jsonPath("$.data_nasterii", notNullValue()));
    }

    @Test
    @DisplayName("GET /utilizator/date-personale without authentication should return 403")
    void getDatePersonale_withoutAuth_shouldReturn403() throws Exception {
        mockMvc.perform(get("/foodtrack/utilizator/date-personale")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isForbidden());
    }

    @Test
    @DisplayName("PATCH /utilizator/modifica-date-personale should update personal data")
    void modificaDatePersonale_shouldUpdateData() throws Exception {
        ModificaDatePersonaleRequest request = mock(ModificaDatePersonaleRequest.class);

        mockMvc.perform(patch("/foodtrack/utilizator/modifica-date-personale")
                        .header("Authorization", "Bearer " + token)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.status", equalTo(200)))
                .andExpect(jsonPath("$.message", containsString("modificate cu succes")))
                .andExpect(jsonPath("$.data", notNullValue()));
    }

    @Test
    @DisplayName("PATCH /utilizator/modifica-date-personale without authentication should return 403")
    void modificaDatePersonale_withoutAuth_shouldReturn403() throws Exception {
        ModificaDatePersonaleRequest request = mock(ModificaDatePersonaleRequest.class);

        mockMvc.perform(patch("/foodtrack/utilizator/modifica-date-personale")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isForbidden());
    }

    @Test
    @DisplayName("PATCH /utilizator/modifica-date-personale with null height should handle gracefully")
    void modificaDatePersonale_nullHeight_shouldHandleGracefully() throws Exception {
        ModificaDatePersonaleRequest request = mock(ModificaDatePersonaleRequest.class);

        mockMvc.perform(patch("/foodtrack/utilizator/modifica-date-personale")
                        .header("Authorization", "Bearer " + token)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.status", equalTo(200)));
    }

    @Test
    @DisplayName("GET /utilizator/date-personale response should contain expected fields")
    void getDatePersonale_shouldContainExpectedFields() throws Exception {
        mockMvc.perform(get("/foodtrack/utilizator/date-personale")
                        .header("Authorization", "Bearer " + token)
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.username", is(notNullValue())))
                .andExpect(jsonPath("$.email", is(notNullValue())))
                .andExpect(jsonPath("$.data_nasterii", is(notNullValue())))
                .andExpect(jsonPath("$.gen", is(notNullValue())));
    }
}