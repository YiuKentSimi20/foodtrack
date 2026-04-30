package com.licenta.foodtrack.controller;


import com.licenta.foodtrack.dto.*;
import com.licenta.foodtrack.model.MasuratoareGrasimeCorporala;
import com.licenta.foodtrack.model.MasuratoareGreutate;
import com.licenta.foodtrack.model.Utilizator;
import com.licenta.foodtrack.service.MasuratoareService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/foodtrack/masuratoare")
@RequiredArgsConstructor
public class MasuratoareController {

    public final MasuratoareService masuratoareService;

    @GetMapping("/masuratori-greutate")
    public ResponseEntity<List<MasuratoareGreutateDto>> getMasuratoriGreutate(@AuthenticationPrincipal Utilizator utilizatorCurent) {

        return ResponseEntity.ok(masuratoareService.getMasuratoriGreutate(utilizatorCurent.getId()));
    }

    @GetMapping("/masuratori-intaltime")
    public ResponseEntity<List<MasuratoareInaltimeDto>> getMasuratoriInaltime(@AuthenticationPrincipal Utilizator utilizatorCurent) {

        return ResponseEntity.ok(masuratoareService.getMasuratoriInaltime(utilizatorCurent.getId()));
    }

    @GetMapping("/masuratori-grasime-corporala")
    public ResponseEntity<List<MasuratoareGrasimeCorporalaDto>> getMasuratoriGrasimeCorporala(@AuthenticationPrincipal Utilizator utilizatorCurent) {

        return ResponseEntity.ok(masuratoareService.getMasuratoriGrasimeCorporala(utilizatorCurent.getId()));
    }

    @GetMapping("/obiective")
    public ResponseEntity<List<ObiectivDto>> getObiective(@AuthenticationPrincipal Utilizator utilizatorCurent) {

        return ResponseEntity.ok(masuratoareService.getObiective(utilizatorCurent.getId()));
    }

    @PostMapping("/greutate")
    public ResponseEntity<ApiResponse<MasuratoareGreutateResponse>> adaugaMasuratoareGreutate(
            @Valid @RequestBody MasuratoareGreutateDto masuratoareGreutateDto,
            @AuthenticationPrincipal Utilizator utilizatorCurent) {

        return ResponseEntity.ok(ApiResponse.<MasuratoareGreutateResponse>builder()
                .status(200)
                .message("Masurătoare de greutate adăugată cu succes")
                .data(masuratoareService.adaugaMasuratoareGreutate(masuratoareGreutateDto, utilizatorCurent.getId()))
                .build()
        );
    }

    @PostMapping("/inaltime")
    public ResponseEntity<ApiResponse<MasuratoareInaltimeResponse>> adaugaMasuratoareInaltime(
            @Valid @RequestBody MasuratoareInaltimeDto masuratoareInaltimeDto,
            @AuthenticationPrincipal Utilizator utilizatorCurent) {


        return ResponseEntity.ok(ApiResponse.<MasuratoareInaltimeResponse>builder()
                .status(200)
                .message("Masurătoare de greutate adăugată cu succes")
                .data(masuratoareService.adaugaMasuratoareInaltime(masuratoareInaltimeDto, utilizatorCurent.getId()))
                .build()
        );
    }

    @PostMapping("/grasime-corporala")
    public ResponseEntity<ApiResponse<MasuratoareGrasimeCorporalaResponse>> adaugaMasuratoareGrasimeCorporala(
            @Valid @RequestBody MasuratoareGrasimeCorporalaDto masuratoareGrasimeCorporalaDto,
            @AuthenticationPrincipal Utilizator utilizatorCurent) {

        return ResponseEntity.ok(ApiResponse.<MasuratoareGrasimeCorporalaResponse>builder()
                .status(200)
                .message("Masurătoare de greutate adăugată cu succes")
                .data(masuratoareService.adaugaMasuratoareGrasimeCorporala(masuratoareGrasimeCorporalaDto, utilizatorCurent.getId()))
                .build()
        );
    }

    @PostMapping("/obiective")
    public ResponseEntity<ApiResponse<ObiectivDto>> adaugaObiectiv(
            @Valid @RequestBody ObiectivDto obiectivDto,
            @AuthenticationPrincipal Utilizator utilizatorCurent) {

        return ResponseEntity.ok(ApiResponse.<ObiectivDto>builder()
                .status(200)
                .message("Obiectiv adăugat cu succes")
                .data(masuratoareService.adaugaObiectiv(obiectivDto, utilizatorCurent.getId()))
                .build()
        );
    }


}
