package com.licenta.foodtrack.model;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeEach;
import java.util.ArrayList;
import static org.junit.jupiter.api.Assertions.*;

@DisplayName("CategorieMasa Entity Tests")
class CategorieMasaTest {
    private CategorieMasa category;

    @BeforeEach
    void setUp() {
        category = new CategorieMasa("Breakfast", 1, true);
        category.setListaMese(new ArrayList<>());
    }

    @Test
    void category_shouldBeCreatedWithConstructor() {
        assertEquals("Breakfast", category.getNume());
        assertEquals(1, category.getNumarOrdine());
        assertTrue(category.getIsActive());
    }

    @Test
    void category_shouldSetAndGetId() {
        category.setId(5L);
        assertEquals(5L, category.getId());
    }

    @Test
    void category_shouldHandleInactiveCategories() {
        CategorieMasa inactive = new CategorieMasa("Snack", 4, false);
        assertFalse(inactive.getIsActive());
    }

    @Test
    void category_shouldMaintainOrderNumber() {
        assertEquals(1, category.getNumarOrdine());
        category.setNumarOrdine(2);
        assertEquals(2, category.getNumarOrdine());
    }

    @Test
    void category_shouldRelateToUtilizator() {
        Utilizator user = new Utilizator();
        category.setUtilizator(user);
        assertEquals(user, category.getUtilizator());
    }

    @Test
    void category_shouldMaintainMealList() {
        Masa meal = new Masa();
        category.getListaMese().add(meal);
        assertEquals(1, category.getListaMese().size());
    }
}