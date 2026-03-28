package com.licenta.foodtrack.controller;


import com.licenta.foodtrack.model.Aliment;
import com.licenta.foodtrack.service.FoodTrackService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/foodtrack")
@RequiredArgsConstructor
public class FoodTrackController
{
    private final FoodTrackService foodTrackService;

    @GetMapping("/product/search-by-name-mock")
    public ResponseEntity<List<Aliment>> searchByNameMock(@RequestParam String name) {
        return ResponseEntity.ok(foodTrackService.searchByNameMock(name));
    }

    @GetMapping("/product/search-by-name")
    public ResponseEntity<List<Aliment>> searchByName(@RequestParam String name) {
        return ResponseEntity.ok(foodTrackService.searchByName(name));
    }

    @GetMapping("product/search-by-barcode")
    public ResponseEntity<Aliment> searchByBarcode(@RequestParam String barcode) {
        Optional<Aliment> aliment = foodTrackService.searchByBarcode(barcode);

        return aliment.map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build());
    }


}
