package com.licenta.foodtrack.exception;

public class BarcodeNotFoundException extends RuntimeException {
    public BarcodeNotFoundException(String message) {
        super(message);
    }
}
