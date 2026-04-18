package com.licenta.foodtrack.controller;


import com.licenta.foodtrack.dto.*;
import com.licenta.foodtrack.model.MasuratoareGrasimeCorporala;
import com.licenta.foodtrack.model.MasuratoareGreutate;
import com.licenta.foodtrack.service.MasuratoareService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/foodtrack/masuratoare")
@RequiredArgsConstructor
public class MasuratoareController {

    public final MasuratoareService masuratoareService;

    //TODO: Implementarea la adaugari si citiri

    @GetMapping("/masuratori-greutate")
    public ResponseEntity<List<MasuratoareGreutateDto>> getMasuratoriGreutate() {

        return ResponseEntity.ok(masuratoareService.getMasuratoriGreutate());
    }

    @GetMapping("/masuratori-intaltime")
    public ResponseEntity<List<MasuratoareInaltimeDto>> getMasuratoriInaltime() {

        return ResponseEntity.ok(masuratoareService.getMasuratoriInaltime());
    }

    @GetMapping("/masuratori-grasime-corporala")
    public ResponseEntity<List<MasuratoareGrasimeCorporalaDto>> getMasuratoriGrasimeCorporala() {

        return ResponseEntity.ok(masuratoareService.getMasuratoriGrasimeCorporala());
    }

    @GetMapping("/obiective")
    public ResponseEntity<List<ObiectivDto>> getObiective() {

        return ResponseEntity.ok(masuratoareService.getObiective());
    }

    @PostMapping("/greutate")
    public ResponseEntity<ApiResponse<MasuratoareGreutateResponse>> adaugaMasuratoareGreutate(@Valid @RequestBody MasuratoareGreutateDto masuratoareGreutateDto) {

        return ResponseEntity.ok(ApiResponse.<MasuratoareGreutateResponse>builder()
                .status(200)
                .message("Masurătoare de greutate adăugată cu succes")
                .data(masuratoareService.adaugaMasuratoareGreutate(masuratoareGreutateDto))
                .build()
        );
    }

    @PostMapping("/inaltime")
    public ResponseEntity<ApiResponse<MasuratoareInaltimeResponse>> adaugaMasuratoareInaltime(@Valid @RequestBody MasuratoareInaltimeDto masuratoareInaltimeDto) {


        return ResponseEntity.ok(ApiResponse.<MasuratoareInaltimeResponse>builder()
                .status(200)
                .message("Masurătoare de greutate adăugată cu succes")
                .data(masuratoareService.adaugaMasuratoareInaltime(masuratoareInaltimeDto))
                .build()
        );
    }

    @PostMapping("/grasime-corporala")
    public ResponseEntity<ApiResponse<MasuratoareGrasimeCorporalaResponse>> adaugaMasuratoareGrasimeCorporala(@Valid @RequestBody MasuratoareGrasimeCorporalaDto masuratoareGrasimeCorporalaDto) {


        return ResponseEntity.ok(ApiResponse.<MasuratoareGrasimeCorporalaResponse>builder()
                .status(200)
                .message("Masurătoare de greutate adăugată cu succes")
                .data(masuratoareService.adaugaMasuratoareGrasimeCorporala(masuratoareGrasimeCorporalaDto))
                .build()
        );
    }

    @PostMapping("/obiective")
    public ResponseEntity<ApiResponse<ObiectivDto>> adaugaObiectiv(@Valid @RequestBody ObiectivDto obiectivDto) {

        return ResponseEntity.ok(ApiResponse.<ObiectivDto>builder()
                .status(200)
                .message("Obiectiv adăugat cu succes")
                .data(masuratoareService.adaugaObiectiv(obiectivDto))
                .build()
        );
    }


}
