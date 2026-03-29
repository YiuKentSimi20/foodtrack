package com.licenta.foodtrack.service;


import com.licenta.foodtrack.repository.UtilizatorRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class UtilizatorService {

    private final UtilizatorRepository utilizatorRepository;


}
