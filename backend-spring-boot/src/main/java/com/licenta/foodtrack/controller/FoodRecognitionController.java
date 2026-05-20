package com.licenta.foodtrack.controller;


import com.licenta.foodtrack.dto.AlimentDto;
import com.licenta.foodtrack.model.Utilizator;
import com.licenta.foodtrack.service.FoodRecognitionService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

@RestController
@RequestMapping("/foodtrack/model")
@RequiredArgsConstructor
public class FoodRecognitionController {

    private final FoodRecognitionService foodRecognitionService;

    @GetMapping("/predict")
    public ResponseEntity<AlimentDto> predictFoodFromImage(
            @RequestParam("file") MultipartFile file,
            @AuthenticationPrincipal Utilizator utilizator) throws IOException {

        return ResponseEntity.ok(foodRecognitionService.predictFoodFromImage(file, utilizator.getId()));
    }
}
