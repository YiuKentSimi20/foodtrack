package com.licenta.foodtrack.exception;

import com.fasterxml.jackson.databind.exc.InvalidFormatException;
import com.licenta.foodtrack.dto.ApiErrorResponse;
import com.licenta.foodtrack.dto.FieldErrorItem;
import io.jsonwebtoken.ExpiredJwtException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;

import static org.springframework.http.ResponseEntity.status;

@RestControllerAdvice
public class ValidationExceptionHandler {

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ApiErrorResponse> handleValidation(MethodArgumentNotValidException ex) {
        Map<String, String> errors = new HashMap<>();
        List<FieldErrorItem> fieldErrors = new ArrayList<>();
        ex.getBindingResult().getFieldErrors()
                .forEach(err -> fieldErrors.add(
                        new FieldErrorItem(err.getField(), err.getRejectedValue(), err.getDefaultMessage())
                ));

        return ResponseEntity.badRequest().body(ApiErrorResponse.builder()
                .status(400)
                .error("VALIDATION_ERROR")
                .message("Validation failed for one or more fields.")
                .fieldErrors(fieldErrors)
                .timestamp(LocalDateTime.now())
                .build()
        );
    }

    @ExceptionHandler(IllegalArgumentException.class)
    public ResponseEntity<ApiErrorResponse> handleIllegalArgument(IllegalArgumentException ex) {
        return ResponseEntity.badRequest().body(ApiErrorResponse.builder()
                .status(400)
                .error("VALIDATION_ERROR")
                .message(ex.getMessage())
                .timestamp(LocalDateTime.now())
                .build()
        );
    }

    @ExceptionHandler(HttpMessageNotReadableException.class)
    public ResponseEntity<ApiErrorResponse> handleNotReadable(HttpMessageNotReadableException ex) {
        Map<String, String> errors = new HashMap<>();
        List<FieldErrorItem> fieldErrors = new ArrayList<>();

        Throwable cause = ex.getCause();
        if (cause instanceof InvalidFormatException ife && LocalDate.class.equals(ife.getTargetType())) {
            String field = ife.getPath().isEmpty()
                    ? "data_nasterii"
                    : ife.getPath().get(ife.getPath().size() - 1).getFieldName();

            fieldErrors.add(new FieldErrorItem(field,
                    "",
                    "Data nasterii invalida. Foloseste formatul yyyy-MM-dd si o data calendaristica valida."));

            return ResponseEntity.badRequest().body(ApiErrorResponse.builder()
                    .status(400)
                    .error("MALFORMED_JSON")
                    .message("Data nasterii invalida. Foloseste formatul yyyy-MM-dd si o data calendaristica valida.")
                    .fieldErrors(fieldErrors)
                    .timestamp(LocalDateTime.now())
                    .build()
            );
        }

        fieldErrors.add(new FieldErrorItem("request", null, "JSON invalid sau format de date incorect."));
        return ResponseEntity.badRequest().body(ApiErrorResponse.builder()
                .status(400)
                .error("MALFORMED_JSON")
                .message("JSON invalid sau format de date incorect.")
                .fieldErrors(fieldErrors)
                .timestamp(LocalDateTime.now())
                .build()
        );
    }

    @ExceptionHandler(IllegalStateException.class)
    public ResponseEntity<ApiErrorResponse> handleIllegalStateException(IllegalStateException ex) {
        return status(HttpStatus.NOT_FOUND).body(ApiErrorResponse.builder()
                .status(404)
                .error("NOT_FOUND")
                .message(ex.getMessage())
                .timestamp(LocalDateTime.now())
                .build());
    }

    @ExceptionHandler(BadCredentialsException.class)
    public ResponseEntity<ApiErrorResponse> handleBadCredentials(BadCredentialsException ex) {
        return status(HttpStatus.UNAUTHORIZED).body(
                ApiErrorResponse.builder()
                        .status(401)
                        .error("INVALID_CREDENTIALS")
                        .message("Invalid username/email or password")
                        .timestamp(LocalDateTime.now())
                        .build()
        );
    }

    @ExceptionHandler(UsernameAlreadyExistsException.class)
    public ResponseEntity<ApiErrorResponse> handleUsernameAlreadyExists(UsernameAlreadyExistsException ex) {

        List<FieldErrorItem> fieldErrors = new ArrayList<>();
        fieldErrors.add(new FieldErrorItem("username", ex.getMessage(), "Username already exists."));

        return status(HttpStatus.CONFLICT).body(
                ApiErrorResponse.builder()
                        .status(409)
                        .error("CONFLICT")
                        .message("Username already exists")
                        .fieldErrors(fieldErrors)
                        .timestamp(LocalDateTime.now())
                        .build()
        );
    }

    @ExceptionHandler(EmailAlreadyExistsException.class)
    public ResponseEntity<ApiErrorResponse> handleEmailAlreadyExists(EmailAlreadyExistsException ex) {

        List<FieldErrorItem> fieldErrors = new ArrayList<>();
        fieldErrors.add(new FieldErrorItem("email", ex.getMessage(), "Email already exists."));

        return status(HttpStatus.CONFLICT).body(
                ApiErrorResponse.builder()
                        .status(409)
                        .error("CONFLICT")
                        .message("Email already exists")
                        .fieldErrors(fieldErrors)
                        .timestamp(LocalDateTime.now())
                        .build()
        );
    }

    @ExceptionHandler(BarcodeNotFoundException.class)
    public ResponseEntity<ApiErrorResponse> handleBarcodeNotFound(BarcodeNotFoundException ex) {

        List<FieldErrorItem> fieldErrors = new ArrayList<>();
        fieldErrors.add(new FieldErrorItem("barcode", ex.getMessage(), "Barcode not found."));

        return status(HttpStatus.NOT_FOUND).body(
                ApiErrorResponse.builder()
                        .status(404)
                        .error("NOT_FOUND")
                        .message("Barcode not found")
                        .fieldErrors(fieldErrors)
                        .build()
        );
    }

    @ExceptionHandler(DataNotBelongingToUserException.class)
    public ResponseEntity<ApiErrorResponse> handleDataNotBelongingToUser(DataNotBelongingToUserException ex) {

        return status(HttpStatus.FORBIDDEN).body(
                ApiErrorResponse.builder()
                        .status(403)
                        .error("FORBIDDEN")
                        .message(ex.getMessage())
                        .build()
        );
    }

    @ExceptionHandler(ObiectivInvalidNutrientsException.class)
    public ResponseEntity<ApiErrorResponse> handleObiectivInvalidNutrients(ObiectivInvalidNutrientsException ex) {

        return status(HttpStatus.BAD_REQUEST).body(
                ApiErrorResponse.builder()
                        .status(400)
                        .error("VALIDATION_ERROR")
                        .message(ex.getMessage())
                        .build()
        );
    }
}
