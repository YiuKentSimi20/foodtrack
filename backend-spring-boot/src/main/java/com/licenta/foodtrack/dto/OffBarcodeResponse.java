package com.licenta.foodtrack.dto;

public record OffBarcodeResponse(
        String code,
        OffProduct product,
        Integer status,
        String status_verbose
) {
}
