package com.licenta.foodtrack.auth;


import com.fasterxml.jackson.annotation.JsonProperty;
import com.licenta.foodtrack.dto.MasuratoareGrasimeCorporalaDto;
import com.licenta.foodtrack.dto.MasuratoareGreutateDto;
import com.licenta.foodtrack.dto.MasuratoareInaltimeDto;
import jakarta.validation.Valid;
import jakarta.validation.constraints.*;

public record RegisterRequest(
        @NotBlank(message = "Username is required")
        @Size(min = 3, max = 20, message = "username must be between 3 and 20 characters")
        String username,

        @NotBlank(message = "email is required")
        @Email(message = "email should be valid")
        @Size(min = 5, max = 50, message = "email must be between 5 and 50 characters")
        String email,

        @NotBlank(message = "password is required")
        @Pattern(
                regexp = "^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[^a-zA-Z0-9])\\S{8,64}$",
                message = "Parola trebuie sa aiba 8-64 caractere, cel putin o litera mica, o litera mare, o cifra si un caracter special, fara spatii"
        )
        String password,

        @NotBlank(message = "data_nasterii is required")
        @Pattern(regexp = "^\\d{4}-\\d{2}-\\d{2}$", message = "Data nasterii must be yyyy-MM-dd")
        @JsonProperty("data_nasterii")
        String dataNasterii,

        String gen,

        @JsonProperty("obiectiv_calorii_zi")
        @Positive(message = "Obiectivul de calorii pe zi trebuie să fie un număr pozitiv")
        Double obiectivCaloriiZi,

        @JsonProperty("obiectiv_greutate_kg")
        @Positive(message = "Obiectivul de greutate în kg trebuie să fie un număr pozitiv")
        Double obiectivGreutateKg,

        @Positive(message = "Obiectivul de proteine pe zi trebuie să fie un număr pozitiv")
        @JsonProperty("obiectiv_proteine_zi")
        @Positive(message = "Obiectivul de proteine pe zi trebuie să fie un număr pozitiv")
        Double obiectivProteineZi,

        @JsonProperty("obiectiv_carbohidrati_zi")
        @Positive(message = "Obiectivul de carbohidrați pe zi trebuie să fie un număr pozitiv")
        Double obiectivCarbohidratiZi,

        @JsonProperty("obiectiv_grasimi_zi")
        @Positive(message = "Obiectivul de grăsimi pe zi trebuie să fie un număr pozitiv")
        Double obiectivGrasimiZi,

        @JsonProperty("nivel_activitate")
        String nivelActivitate,

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
        @JsonProperty("masuratoare_grasime_corporala")
        MasuratoareGrasimeCorporalaDto masuratoareGrasimeCorporalaDto,

        @Valid
        @JsonProperty("masuratoare_greutate")
        MasuratoareGreutateDto masuratoareGreutateDto,

        @Valid
        @JsonProperty("masuratoare_inaltime")
        MasuratoareInaltimeDto masuratoareInaltimeDto
) {}
