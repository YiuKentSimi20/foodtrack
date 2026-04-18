package com.licenta.foodtrack.controller;


import com.licenta.foodtrack.exception.ValidationExceptionHandler;
import com.licenta.foodtrack.model.Aliment;
import com.licenta.foodtrack.service.AlimentService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

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
    public ResponseEntity<List<Aliment>> searchByNameMock(@RequestParam String name) {
        return ResponseEntity.ok(alimentService.searchByNameMock(name));
    }

    @GetMapping("/search-by-name")
    public ResponseEntity<List<Aliment>> searchByName(@RequestParam String name) {
        return ResponseEntity.ok(alimentService.searchByName(name));
    }

    @GetMapping("/search-by-barcode")
    public ResponseEntity<Aliment> searchByBarcode(@RequestParam String barcode) {

        return ResponseEntity.ok(alimentService.searchByBarcode(barcode));
    }

    //TODO: Creeare Aliment

}
