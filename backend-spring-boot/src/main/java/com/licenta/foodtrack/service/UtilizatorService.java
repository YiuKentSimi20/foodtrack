package com.licenta.foodtrack.service;


import com.licenta.foodtrack.auth.RegisterRequest;
import com.licenta.foodtrack.mapper.UtilizatorMapper;
import com.licenta.foodtrack.model.RolUtilizator;
import com.licenta.foodtrack.model.Utilizator;
import com.licenta.foodtrack.repository.UtilizatorRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class UtilizatorService {

//    private final UtilizatorRepository utilizatorRepository;
//    private final UtilizatorMapper utilizatorMapper;
//
//    public Utilizator register(RegisterRequest registerRequest) {
//        Utilizator utilizator = utilizatorMapper.toUtilizator(registerRequest);
//        utilizator.setRole(RolUtilizator.USER);
//        utilizatorRepository.save(utilizator);
//        return utilizator;
//    }


}
