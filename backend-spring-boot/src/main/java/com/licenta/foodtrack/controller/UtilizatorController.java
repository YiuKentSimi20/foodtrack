package com.licenta.foodtrack.controller;

import com.licenta.foodtrack.dto.ApiResponse;
import com.licenta.foodtrack.dto.DatePersonaleResponse;
import com.licenta.foodtrack.dto.ModificaDatePersonaleRequest;
import com.licenta.foodtrack.model.Utilizator;
import com.licenta.foodtrack.service.UtilizatorService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/foodtrack/utilizator")
@RequiredArgsConstructor
public class UtilizatorController {

    private final UtilizatorService utilizatorService;

    @GetMapping("/date-personale")
    public ResponseEntity<DatePersonaleResponse> getDatePersonale(@AuthenticationPrincipal Utilizator utilizatorCurent) {

            return ResponseEntity.ok(utilizatorService.getDatePersonale(utilizatorCurent.getId()));
    }

    @PatchMapping("/modifica-date-personale")
    public ResponseEntity<ApiResponse<DatePersonaleResponse>> modificaDatePersonale(
            @RequestBody ModificaDatePersonaleRequest request,
            @AuthenticationPrincipal Utilizator utilizatorCurent) {

        return ResponseEntity.ok(ApiResponse.<DatePersonaleResponse>builder()
                .status(200)
                .message("Datele personale au fost modificate cu succes")
                .data(utilizatorService.modificaDatePersonale(request, utilizatorCurent.getId()))
                .build()
        );
    }
}
