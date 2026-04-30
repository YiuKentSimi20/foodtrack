package com.licenta.foodtrack.controller;


import com.licenta.foodtrack.dto.AlimentDto;
import com.licenta.foodtrack.dto.ApiResponse;
import com.licenta.foodtrack.dto.CreateAlimentRequest;
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
import java.util.Optional;

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
            @AuthenticationPrincipal Utilizator utilizatorCurent) {

        return ResponseEntity.ok(alimentService.searchByNameMock(name, utilizatorCurent.getId()));
    }

    @GetMapping("/search-by-name")
    public ResponseEntity<List<Aliment>> searchByName(
            @RequestParam String name,
            @AuthenticationPrincipal Utilizator utilizatorCurent) {

        return ResponseEntity.ok(alimentService.searchByName(name, utilizatorCurent.getId()));
    }

    @GetMapping("/search-by-barcode")
    public ResponseEntity<Aliment> searchByBarcode(@RequestParam String barcode) {

        return ResponseEntity.ok(alimentService.searchByBarcode(barcode));
    }
    
    @PostMapping()
    public ResponseEntity<ApiResponse<AlimentDto>> addAliment(
            @Valid @RequestBody CreateAlimentRequest request,
            @AuthenticationPrincipal Utilizator utilizatorCurent) {

        return ResponseEntity.ok(ApiResponse.<AlimentDto>builder()
                .status(200)
                .message("Aliment adăugat cu succes")
                .data(alimentService.addAliment(request, utilizatorCurent.getId()))
                .build()
        );
    }

    @PutMapping()
    public ResponseEntity<ApiResponse<AlimentDto>> updateAliment(
            @Valid @RequestBody CreateAlimentRequest request,
            @RequestParam Long id,
            @AuthenticationPrincipal Utilizator utilizatorCurent) {

        return ResponseEntity.ok(ApiResponse.<AlimentDto>builder()
                .status(200)
                .message("Aliment actualizat cu succes")
                .data(alimentService.updateAliment(request, id, utilizatorCurent.getId()))
                .build()
        );
    }

    @PatchMapping("/validate")
    public ResponseEntity<String> validateAliment(@RequestParam Long id) {

        return ResponseEntity.ok("Acces la validarea alimentelor");
    }

}
