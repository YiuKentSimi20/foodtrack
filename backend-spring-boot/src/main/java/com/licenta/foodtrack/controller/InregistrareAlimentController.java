package com.licenta.foodtrack.controller;


import com.licenta.foodtrack.service.InregistrareAlimentService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.RestController;

@RestController("foodtrack/inregistrare-aliment")
@RequiredArgsConstructor
public class InregistrareAlimentController {

    private final InregistrareAlimentService inregistrareAlimentService;

}
