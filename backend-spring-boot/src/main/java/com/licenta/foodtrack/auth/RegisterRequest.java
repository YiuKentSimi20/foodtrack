package com.licenta.foodtrack.auth;


import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.licenta.foodtrack.dto.MasuratoareGrasimeCorporalaDto;
import com.licenta.foodtrack.dto.MasuratoareGreutateDto;
import com.licenta.foodtrack.dto.MasuratoareInaltimeDto;
import com.licenta.foodtrack.dto.ObiectivDto;
import com.licenta.foodtrack.model.GenUtilizator;
import com.licenta.foodtrack.model.NivelActivitate;
import jakarta.validation.Valid;
import jakarta.validation.constraints.*;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDate;

public record RegisterRequest(

        @NotBlank(message = "Username is required")
        @Size(min = 3, max = 20, message = "username must be between 3 and 20 characters")
        String username,

        @NotBlank(message = "email is required")
        @Email(message = "email should be valid")
        String email,

        @NotBlank(message = "password is required")
        @Pattern(
                regexp = "^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[^a-zA-Z0-9])\\S{8,64}$",
                message = "Parola trebuie sa aiba 8-64 caractere, litera mica, litera mare, cifra, caracter special"
        )
        String password,

        @NotNull(message = "data_nasterii is required")
        @Past(message = "data_nasterii trebuie sa fie in trecut")
        @JsonProperty("data_nasterii")
        @JsonFormat(pattern = "yyyy-MM-dd")
        LocalDate dataNasterii,

        GenUtilizator gen,

        @JsonProperty("nivel_activitate")
        NivelActivitate nivelActivitate,

        @JsonProperty("imc")
        @Positive(message = "Indicele de masă corporală trebuie să fie un număr pozitiv")
        Double indiceMasaCorporala,

        @JsonProperty("bmr")
        @Positive(message = "Rata metabolică bazală trebuie să fie un număr pozitiv")
        Double rataMetabolicaBazala,

        @JsonProperty("tdee")
        @Positive(message = "Necesarul caloric de menținere trebuie să fie un număr pozitiv")
        Double necesarCaloricMentinere,

        @Valid
        @JsonProperty("obiectiv")
        ObiectivDto obiectivDto,

        @Valid
        @JsonProperty("masuratoare_grasime_corporala")
        MasuratoareGrasimeCorporalaDto masuratoareGrasimeCorporalaDto,

        @Valid
        @JsonProperty("masuratoare_greutate")
        MasuratoareGreutateDto masuratoareGreutateDto,

        @Valid
        @JsonProperty("masuratoare_inaltime")
        MasuratoareInaltimeDto masuratoareInaltimeDto
) {}
