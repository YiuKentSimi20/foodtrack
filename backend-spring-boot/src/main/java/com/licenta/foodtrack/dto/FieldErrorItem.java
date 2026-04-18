package com.licenta.foodtrack.dto;

public record FieldErrorItem(
        String field,
        Object rejectedValue,
        String message
) {
}