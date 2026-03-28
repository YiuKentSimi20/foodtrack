package com.licenta.foodtrack.service;

import com.licenta.foodtrack.dto.OffBarcodeResponse;
import com.licenta.foodtrack.dto.OffProduct;
import com.licenta.foodtrack.dto.OffSearchResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.io.ClassPathResource;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.HttpServerErrorException;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;
import tools.jackson.databind.ObjectMapper;

import java.io.InputStream;
import java.net.URI;
import java.util.Collections;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class OpenFoodFactsService {

    private final RestTemplate restTemplate;
    private final ObjectMapper objectMapper;


    public List<OffProduct> searchProductsMock(String keyword) {
        try {

            InputStream is = new ClassPathResource("mock_products.json").getInputStream();

            OffSearchResponse response = objectMapper.readValue(is, OffSearchResponse.class);

            if (response.products() != null) {
                return response.products().stream()
                        .filter(p -> p.productName() != null &&
                                p.productName().toLowerCase().contains(keyword.toLowerCase()))
                        .collect(Collectors.toList());
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return Collections.emptyList();
    }


    private HttpEntity<String> createRequestEntity() {
        HttpHeaders headers = new HttpHeaders();
        headers.set("User-Agent", "FoodTrackApp - Android/Java - Versiunea 1.0 - alexandru@email.com");

        return new HttpEntity<>(headers);
    }

    public Optional<OffBarcodeResponse> getProductByBarcode(String barcode) {
        String url = "https://world.openfoodfacts.org/api/v2/product/" + barcode +
                ".json?fields=code,product_name,abbreviated_product_name,nutriments,image_url,nutrition_grades,categories";
        try {
            ResponseEntity<OffBarcodeResponse> response = restTemplate.exchange(
                    url,
                    HttpMethod.GET,
                    createRequestEntity(), // Aici punem costumul creat mai sus
                    OffBarcodeResponse.class
            );

            return Optional.ofNullable(response.getBody());
        } catch (HttpClientErrorException e) {
            if (e.getStatusCode().value() == 404) {
                return Optional.empty();
            } else {
                throw e;
            }
        }
    }

    public List<OffProduct> searchProductsByName(String name) {

        String url = UriComponentsBuilder.fromUri(URI.create("https://world.openfoodfacts.org/cgi/search.pl"))
                .queryParam("search_terms", name)
                .queryParam("search_simple", "1")
                .queryParam("action", "process")
                .queryParam("json", "1")
                .queryParam("page_size", "10") // Aducem doar primele 10 rezultate
                .queryParam("fields", "code,product_name,nutriments,image_url")
                .toUriString();
        try {
            ResponseEntity<OffSearchResponse> response = restTemplate.exchange(
                    url,
                    HttpMethod.GET,
                    createRequestEntity(),
                    OffSearchResponse.class
            );

            assert response.getBody() != null;
            return response.getBody().products();

        } catch (HttpServerErrorException e) {
            if (e.getStatusCode().value() == 503) {
                log.warn("OpenFoodFacts API is currently unavailable (503). Returning empty product list.");
                return Collections.emptyList();
            } else {
                throw e;
            }
        }
    }
}
