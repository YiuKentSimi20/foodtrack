package com.licenta.foodtrack.controller;

import com.licenta.foodtrack.dto.*;
import com.licenta.foodtrack.model.Utilizator;
import com.licenta.foodtrack.service.ActivitateFizicaService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/foodtrack/activitate-fizica")
@RequiredArgsConstructor
public class ActivitateFizicaController {

    final private ActivitateFizicaService activitateFizicaService;

    @GetMapping()
    public ResponseEntity<List<ActivitateFizicaDto>> getActivitatiFizice(
            @AuthenticationPrincipal Utilizator utilizator) {

        return ResponseEntity.ok(activitateFizicaService.getActivitatiFizice(utilizator.getId()));
    }

    @PostMapping()
    public ResponseEntity<ApiResponse<InregistrareActivitateFizicaResponse>> adaugaInregistrareActivitateFizica(
            @Valid @RequestBody InregistrareActivitateFizicaRequest request,
            @AuthenticationPrincipal Utilizator utilizator) {

        return ResponseEntity.ok(ApiResponse.<InregistrareActivitateFizicaResponse>builder()
                .status(200)

                .message("Activitate fizică adăugată cu succes")
                .data(activitateFizicaService.adaugaInregistrareActivitateFizica(request, utilizator.getId()))
                .build());
    }

    @PatchMapping()
    public ResponseEntity<ApiResponse<InregistrareActivitateFizicaResponse>> modificaInregistrareActivitateFizica(
            @Valid @RequestBody ModificaInregistrareActivitateFizicaRequest request,
            @AuthenticationPrincipal Utilizator utilizator) {

        return ResponseEntity.ok(ApiResponse.<InregistrareActivitateFizicaResponse>builder()
                .status(200)
                .message("Activitate fizică modificată cu succes")
                .data(activitateFizicaService.modificaInregistrareActivitateFizica(request, utilizator.getId()))
                .build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> stergeInregistrareActivitateFizica(
            @PathVariable Long id,
            @AuthenticationPrincipal Utilizator utilizator) {

        activitateFizicaService.stergeInregistrareActivitateFizica(id, utilizator.getId());

        return ResponseEntity.ok(ApiResponse.<Void>builder()
                .status(200)
                .message("Activitate fizică ștearsă cu succes")
                .build());
    }

    @PostMapping("/health-connect")
    public ResponseEntity<ApiResponse<List<InregistrareActivitateFizicaResponse>>> adaugaInregistrareHealthConnect(
            @Valid @RequestBody List<HealthConnectRequest> request,
            @AuthenticationPrincipal Utilizator utilizator
            ) {

        return ResponseEntity.ok(ApiResponse.<List<InregistrareActivitateFizicaResponse>>builder()
                .status(200)
                .message("Activitate fizică adăugată cu succes din Health Connect")
                .data(activitateFizicaService.adaugaInregistrareHealthConnect(request, utilizator.getId()))
                .build());
    }
}
