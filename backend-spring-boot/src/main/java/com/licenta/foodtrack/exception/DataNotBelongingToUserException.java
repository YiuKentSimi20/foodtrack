package com.licenta.foodtrack.exception;

public class DataNotBelongingToUserException extends RuntimeException {
    public DataNotBelongingToUserException(String message) {
        super(message);
    }
}
