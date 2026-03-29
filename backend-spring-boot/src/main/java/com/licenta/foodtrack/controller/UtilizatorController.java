package com.licenta.foodtrack.controller;


import com.licenta.foodtrack.service.UtilizatorService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.RestController;

@RestController("/user")
@RequiredArgsConstructor
public class UtilizatorController {
    public final UtilizatorService utilizatorService;


}
