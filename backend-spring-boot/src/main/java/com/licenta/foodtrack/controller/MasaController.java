package com.licenta.foodtrack.controller;


import com.licenta.foodtrack.dto.*;
import com.licenta.foodtrack.model.Utilizator;
import com.licenta.foodtrack.service.MasaService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;

import static org.springframework.http.ResponseEntity.status;

@RestController
@RequestMapping("/foodtrack/masa")
@RequiredArgsConstructor
public class MasaController {

    private final MasaService masaService;

    @GetMapping("/{id}")
    public ResponseEntity<MasaResponse> getMasaById(@PathVariable Long id, @AuthenticationPrincipal Utilizator utilizator){

        return ResponseEntity.ok(masaService.getMasaById(id, utilizator.getId()));
    }

    @GetMapping("/mese")
    public ResponseEntity<List<MasaResponse>> getMese(
            @RequestParam(required = false) LocalDate startingDate,
            @RequestParam(required = false) LocalDate endingDate,
            @AuthenticationPrincipal Utilizator utilizatorCurent) {

        return ResponseEntity.ok(masaService.getMese(startingDate, endingDate, utilizatorCurent.getId()));
    }

    @GetMapping("/raport")
    public ResponseEntity<List<MesePeZiResponse>> getRaport(
            @RequestParam LocalDate startDate,
            @RequestParam LocalDate endDate,
            @AuthenticationPrincipal Utilizator utilizator) {

        return ResponseEntity.ok(masaService.getRaport(startDate, endDate, utilizator.getId()));

    }

    @PostMapping("/adauga-inregistrare-aliment")
    public ResponseEntity<ApiResponse<InregistrareAlimentResponse>> adaugaInregistrareAliment(
            @RequestBody InregistrareAlimentRequest request,
            @AuthenticationPrincipal Utilizator utilizator) {

        return ResponseEntity.ok(ApiResponse.<InregistrareAlimentResponse>builder()
                .status(200)
                .message("Aliment adăugat cu succes" + request.data())
                .data(masaService.adaugaInregistrareAliment(request, utilizator.getId()))
                .build()
        );
    }

    @PostMapping("/inregistrare-manuala")
    public ResponseEntity<ApiResponse<InregistrareAlimentResponse>> inregistrareManuala(
            @RequestBody InregistrareManualaRequest request,
            @AuthenticationPrincipal Utilizator utilizator) {

        return ResponseEntity.ok(ApiResponse.<InregistrareAlimentResponse>builder()
                .status(200)
                .message("Aliment adăugat manual cu succes la masa" + request.data())
                .data(masaService.adaugaInregistrareManuala(request, utilizator.getId()))
                .build()
        );
    }

    @DeleteMapping("/sterge-inregistrare-aliment/{id}")
    public ResponseEntity<ApiResponse<Void>> stergeInregistrareAlimentBy(@PathVariable Long id, @AuthenticationPrincipal Utilizator utilizator) {

        masaService.stergeInregistrareAliment(id,  utilizator.getId());

        return ResponseEntity.ok(ApiResponse.<Void>builder()
                .status(200)
                .message("Înregistrarea alimentului a fost ștearsă cu succes.")
                .build()
        );
    }


    @PatchMapping("/modifica-gramaj-inregistrare-aliment")
    public ResponseEntity<ApiResponse<InregistrareAlimentResponse>> modificaGramajInregistrareAliment(
            @RequestBody ModificareGramajInregistrareAlimentRequest request,
            @AuthenticationPrincipal Utilizator utilizator) {

        return ResponseEntity.ok(ApiResponse.<InregistrareAlimentResponse>builder()
                .status(200)
                .message("Gramajul înregistrării alimentului a fost modificat cu succes.")
                .data(masaService.modificaGramajInregistrareAliment(request, utilizator.getId()))
                .build()
        );
    }

    @PatchMapping("/modifica-inregistrare-manuala")
    public ResponseEntity<ApiResponse<InregistrareAlimentResponse>> modificaInregistrareManuala(
            @RequestBody ModificareInregistrareManualaRequest request,
            @AuthenticationPrincipal Utilizator utilizator) {

        return ResponseEntity.ok(ApiResponse.<InregistrareAlimentResponse>builder()
                .status(200)
                .message("Înregistrarea a fost modificată cu succes.")
                .data(masaService.modificaInregistrareManuala(request, utilizator.getId()))
                .build()
        );
    }

    @GetMapping("/categorie-masa")
    public ResponseEntity<List<CategorieMasaDto>> getCategoriiMese(@AuthenticationPrincipal Utilizator utilizator) {

        return ResponseEntity.ok(masaService.getCategoriiMese(utilizator.getId()));
    }

    @PutMapping("/categorie-masa")
    public ResponseEntity<ApiResponse<List<CategorieMasaDto>>> updateCategoriiMese(
            @Valid @RequestBody UpdateCategoriiMeseRequest request,
            @AuthenticationPrincipal Utilizator utilizatorCurent) {

        return ResponseEntity.ok(ApiResponse.<List<CategorieMasaDto>>builder()
                .status(200)
                .message("Categoriile de mese au fost actualizate cu succes.")
                .data(masaService.updateCategoriiMese(request, utilizatorCurent.getId()))
                .build()
        );
    }

}
