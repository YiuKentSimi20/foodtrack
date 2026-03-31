package com.licenta.foodtrack.exception;

import com.fasterxml.jackson.databind.exc.InvalidFormatException;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.Map;

@RestControllerAdvice
public class ValidationExceptionHandler {

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<Map<String, String>> handleValidation(MethodArgumentNotValidException ex) {
        Map<String, String> errors = new HashMap<>();
        ex.getBindingResult().getFieldErrors()
                .forEach(err -> errors.put(err.getField(), err.getDefaultMessage()));
        return ResponseEntity.badRequest().body(errors);
    }

    @ExceptionHandler(HttpMessageNotReadableException.class)
    public ResponseEntity<Map<String, String>> handleNotReadable(HttpMessageNotReadableException ex) {
        Map<String, String> errors = new HashMap<>();

        Throwable cause = ex.getCause();
        if (cause instanceof InvalidFormatException ife && LocalDate.class.equals(ife.getTargetType())) {
            String field = ife.getPath().isEmpty()
                    ? "data_nasterii"
                    : ife.getPath().get(ife.getPath().size() - 1).getFieldName();

            errors.put(field, "Data nasterii invalida. Foloseste formatul yyyy-MM-dd si o data calendaristica valida.");
            return ResponseEntity.badRequest().body(errors);
        }

        errors.put("request", "JSON invalid sau format de date incorect.");
        return ResponseEntity.badRequest().body(errors);
    }
}
