package com.licenta.foodtrack.service;

import com.licenta.foodtrack.repository.InregistrareAlimentRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class InregistrareAlimentService {
    private final InregistrareAlimentRepository inregistrareAlimentRepository;


}
