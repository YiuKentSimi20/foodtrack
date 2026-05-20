package com.licenta.foodtrack.controller;


import com.licenta.foodtrack.dto.AlimentDto;
import com.licenta.foodtrack.dto.ApiResponse;
import com.licenta.foodtrack.dto.CreateAlimentRequest;
import com.licenta.foodtrack.dto.DetaliiAlimentResponse;
import com.licenta.foodtrack.exception.ValidationExceptionHandler;
import com.licenta.foodtrack.model.Aliment;
import com.licenta.foodtrack.model.Utilizator;
import com.licenta.foodtrack.service.AlimentService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/foodtrack/aliment")
@RequiredArgsConstructor
public class AlimentController
{
    private final AlimentService alimentService;
    private final ValidationExceptionHandler validationExceptionHandler;

    @GetMapping("/search-by-name-mock")
    public ResponseEntity<List<Aliment>> searchByNameMock(
            @RequestParam String name,
            @AuthenticationPrincipal Utilizator utilizator) {

        return ResponseEntity.ok(alimentService.searchByNameMock(name, utilizator.getId()));
    }

    @GetMapping("/search-by-name")
    public ResponseEntity<List<AlimentDto>> searchByName(
            @RequestParam String name,
            @AuthenticationPrincipal Utilizator utilizator) {

        return ResponseEntity.ok(alimentService.searchByName(name, utilizator.getId()));
    }

    @GetMapping("/search-by-barcode")
    public ResponseEntity<AlimentDto> searchByBarcode(@RequestParam String barcode, @AuthenticationPrincipal Utilizator utilizator) {

        return ResponseEntity.ok(alimentService.searchByBarcode(barcode, utilizator.getId()));
    }
    
    @PostMapping()
    public ResponseEntity<ApiResponse<AlimentDto>> addAliment(
            @Valid @RequestBody CreateAlimentRequest request,
            @AuthenticationPrincipal Utilizator utilizator) {

        return ResponseEntity.ok(ApiResponse.<AlimentDto>builder()
                .status(200)
                .message("Aliment adăugat cu succes")
                .data(alimentService.addAliment(request, utilizator.getId()))
                .build()
        );
    }

    @PutMapping()
    public ResponseEntity<ApiResponse<AlimentDto>> updateAliment(
            @Valid @RequestBody CreateAlimentRequest request,
            @RequestParam Long id,
            @AuthenticationPrincipal Utilizator utilizator) {

        return ResponseEntity.ok(ApiResponse.<AlimentDto>builder()
                .status(200)
                .message("Aliment actualizat cu succes")
                .data(alimentService.updateAliment(request, id, utilizator.getId()))
                .build()
        );
    }

    @PatchMapping("/validate")
    public ResponseEntity<ApiResponse<AlimentDto>> validateAliment(@RequestParam Long id) {

        return ResponseEntity.ok(ApiResponse.<AlimentDto>builder()
                .status(200)
                .message("Aliment validat cu succes")
                .data(alimentService.validateAliment(id))
                .build()
        );
    }

    @GetMapping("/alimente-utilizator")
    public ResponseEntity<List<AlimentDto>> getAlimenteUtilizator(@AuthenticationPrincipal Utilizator utilizator) {

        return ResponseEntity.ok(alimentService.getAlimenteUtilizator(utilizator.getId()));
    }

    @GetMapping("/alimente-nevalidate")
    public ResponseEntity<List<AlimentDto>> getAlimenteNevalidate(@AuthenticationPrincipal Utilizator utilizator) {

        return ResponseEntity.ok(alimentService.getAlimenteNevalidate(utilizator.getId()));
    }

    @GetMapping("/detalii")
    public ResponseEntity<DetaliiAlimentResponse> getDetaliiAliment(
            @RequestBody AlimentDto alimentDto,
            @AuthenticationPrincipal Utilizator uilizator
    ) {

        return ResponseEntity.ok(alimentService.getDetaliiAliment(alimentDto, uilizator.getId()));
    }

}
