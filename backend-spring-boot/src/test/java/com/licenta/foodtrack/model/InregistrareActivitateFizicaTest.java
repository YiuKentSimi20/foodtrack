package com.licenta.foodtrack.model;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeEach;
import java.time.LocalDate;
import static org.junit.jupiter.api.Assertions.*;

@DisplayName("InregistrareActivitateFizica Entity Tests")
class InregistrareActivitateFizicaTest {
    private InregistrareActivitateFizica activity;

    @BeforeEach
    void setUp() {
        activity = new InregistrareActivitateFizica();
        activity.setId(1L);
        activity.setNume("Morning Run");
        activity.setDataActivitate(LocalDate.of(2026, 5, 28));
        activity.setMet(6.0);
        activity.setCategorie(CategorieActivitate.CARDIO);
        activity.setDurataMin(30.0);
        activity.setCaloriiArse(210.0);
        activity.setNumarPasi(5000);
        activity.setUtilizatorKg(70.0);
        activity.setSursaDate(SursaDate.MANUAL);
    }

    @Test
    void activity_shouldStoreCorrectData() {
        assertEquals("Morning Run", activity.getNume());
        assertEquals(LocalDate.of(2026, 5, 28), activity.getDataActivitate());
        assertEquals(6.0, activity.getMet());
    }

    @Test
    void activity_shouldStoreCategory() {
        assertEquals(CategorieActivitate.CARDIO, activity.getCategorie());
    }

    @Test
    void activity_shouldStoreDuration() {
        assertEquals(30.0, activity.getDurataMin());
    }

    @Test
    void activity_shouldStoreCaloriesBurned() {
        assertEquals(210.0, activity.getCaloriiArse());
    }

    @Test
    void activity_shouldStoreStepCount() {
        assertEquals(5000, activity.getNumarPasi());
    }

    @Test
    void activity_shouldStoreDataSource() {
        assertEquals(SursaDate.MANUAL, activity.getSursaDate());
    }

    @Test
    void activity_shouldAllowNullNotes() {
        assertNull(activity.getNotite());
        activity.setNotite("Hard workout");
        assertEquals("Hard workout", activity.getNotite());
    }
}