package com.licenta.foodtrack.service;

import com.licenta.foodtrack.dto.AlimentDto;
import com.licenta.foodtrack.dto.PredictFoodResponse;
import com.licenta.foodtrack.exception.PredictionNotSureException;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.HttpServerErrorException;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class FoodRecognitionService {

    private final RestTemplate restTemplate;
    private final AlimentService alimentService;

    @Value("${my.ai_service.url}")
    String fastApiUrl;

    public AlimentDto predictFoodFromImage(
            MultipartFile file,
            UUID idUtilizator) throws IOException, HttpClientErrorException, HttpServerErrorException {

        String predictUrl = fastApiUrl + "/api/predict";

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.MULTIPART_FORM_DATA);

        MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();

        ByteArrayResource fileAsResource = new ByteArrayResource(file.getBytes()) {
            @Override
            public String getFilename() {
                return file.getOriginalFilename();
            }
        };

        HttpEntity<MultiValueMap<String, Object>> requestEntity = new HttpEntity<>(body, headers);
        body.add("file", fileAsResource);

        ResponseEntity<PredictFoodResponse> response = restTemplate.exchange(
                    predictUrl,
                    HttpMethod.POST,
                    requestEntity,
                    PredictFoodResponse.class
            );

        PredictFoodResponse predictFoodResponse = response.getBody();
        assert predictFoodResponse != null;

        if(predictFoodResponse.mancare().equals("unknown")) {
            throw new PredictionNotSureException("Nu s-a putut recunoaște mâncarea din imagine.");
        }

        return alimentService.searchByBarcode(predictFoodResponse.mancare(), idUtilizator);

    }

}
