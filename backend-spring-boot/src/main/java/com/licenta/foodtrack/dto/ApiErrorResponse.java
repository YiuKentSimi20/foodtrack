package com.licenta.foodtrack.dto;


import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.*;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@JsonInclude(JsonInclude.Include.NON_NULL)
public class ApiErrorResponse {
    private int status;
    private String error;
    private String message;
    private String path;
    LocalDateTime timestamp;
    List<FieldErrorItem> fieldErrors;


    public ApiErrorResponse(int status, String error, String message, String path, List<FieldErrorItem> fieldErrors) {

        this.status = status;
        this.error = error;
        this.message = message;
        this.path = path;
        this.timestamp = LocalDateTime.now();
        this.fieldErrors = fieldErrors;
    }
}
