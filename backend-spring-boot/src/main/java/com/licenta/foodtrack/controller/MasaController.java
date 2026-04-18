package com.licenta.foodtrack.controller;


import com.licenta.foodtrack.dto.*;
import com.licenta.foodtrack.service.MasaService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;

import static org.springframework.http.ResponseEntity.status;

@RestController
@RequestMapping("/foodtrack/masa")
@RequiredArgsConstructor
public class MasaController {

    private final MasaService masaService;

    //TODO: Modificare Gramaj inregistrare, Stergere Inregistrare
    //TODO: Modificare inregistrare manuala, Stergere inregistrare manuala

    @GetMapping("/mese")
    public ResponseEntity<ApiResponse<Object>> getMese(
            @RequestParam(required = false) LocalDate startingDate,
            @RequestParam(required = false) LocalDate endingDate) {

        return ResponseEntity.ok(ApiResponse.builder()
                .status(200)
                .data(masaService.getMese(startingDate, endingDate))
                .build());
    }

    @GetMapping("/raport")
    public ResponseEntity<ApiResponse<Object>> getRaport() {
        return ResponseEntity.ok(ApiResponse.<Object>builder()
                .status(200)
                .data(masaService.getRaport())
                .build()
        );
    }

    @PostMapping("/adauga-inregistrare-aliment")
    public ResponseEntity<ApiResponse<InregistrareAlimentResponse>> adaugaInregistrareAliment(@RequestBody InregistrareAlimentRequest request) {

        return ResponseEntity.ok(ApiResponse.<InregistrareAlimentResponse>builder()
                .status(200)
                .message("Aliment adăugat cu succes la masa " + request.numeMasa() + " din data " + request.data())
                .data(masaService.adaugaInregistrareAliment(request))
                .build()
        );
    }

    @PostMapping("/inregistrare-manuala")
    public ResponseEntity<ApiResponse<InregistrareAlimentResponse>> inregistrareManuala(@RequestBody InregistrareManualaRequest request) {

        return ResponseEntity.ok(ApiResponse.<InregistrareAlimentResponse>builder()
                .status(200)
                .message("Aliment adăugat manual cu succes la masa " + request.numeMasa() + " din data " + request.data())
                .data(masaService.adaugaInregistrareManuala(request))
                .build()
        );
    }

    @DeleteMapping("/sterge-inregistrare-aliment/{id}")
    public ResponseEntity<ApiResponse<Void>> stergeInregistrareAlimentBy(@PathVariable Long id) {

        masaService.stergeInregistrareAliment(id);

        return ResponseEntity.ok(ApiResponse.<Void>builder()
                .status(200)
                .message("Înregistrarea alimentului a fost ștearsă cu succes.")
                .build()
        );
    }


    @PatchMapping("/modifica-gramaj-inregistrare-aliment")
    public ResponseEntity<ApiResponse<InregistrareAlimentResponse>> modificaGramajInregistrareAliment(@RequestBody ModificareGramajInregistrareAlimentRequest request) {
        return ResponseEntity.ok(ApiResponse.<InregistrareAlimentResponse>builder()
                .status(200)
                .message("Gramajul înregistrării alimentului a fost modificat cu succes.")
                .data(masaService.modificaGramajInregistrareAliment(request))
                .build()
        );
    }

    @PatchMapping("/modifica-inregistrare-manuala")
    public ResponseEntity<ApiResponse<InregistrareAlimentResponse>> modificaInregistrareManuala(@RequestBody ModificareInregistrareManualaRequest request) {
        return ResponseEntity.ok(ApiResponse.<InregistrareAlimentResponse>builder()
                .status(200)
                .message("Înregistrarea a fost modificată cu succes.")
                .data(masaService.modificaInregistrareManuala(request))
                .build()
        );
    }

}
