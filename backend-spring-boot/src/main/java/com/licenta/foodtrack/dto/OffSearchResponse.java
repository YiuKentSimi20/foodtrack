package com.licenta.foodtrack.dto;

import java.util.List;

public record OffSearchResponse(
        List<OffProduct> products
) {
}
