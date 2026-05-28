package com.licenta.foodtrack.util;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.Nested;

import static org.junit.jupiter.api.Assertions.*;

@DisplayName("MacroPercents Calculator Tests")
class MacroProcentsCalculatorTest {

    @Nested
    @DisplayName("Basic Calculation Tests")
    class BasicCalculationTests {

        @Test
        @DisplayName("calcPercents should sum to exactly 1.0")
        void calcPercents_shouldSumToOne() {
            MacroProcentsCalculator.MacroPercents result = MacroProcentsCalculator.calcPercentsSumOne(50, 150, 100);

            double sum = result.fatPercent() + result.carbsPercent() + result.proteinPercent();

            assertEquals(1.0, sum, 0.001);
        }

        @Test
        @DisplayName("calcPercents with zero macros should return zeros")
        void calcPercents_withZeroMacros_shouldReturnZeros() {
            MacroProcentsCalculator.MacroPercents result = MacroProcentsCalculator.calcPercentsSumOne(0, 0, 0);

            assertEquals(0.0, result.fatPercent());
            assertEquals(0.0, result.carbsPercent());
            assertEquals(0.0, result.proteinPercent());
        }

        @Test
        @DisplayName("calcPercents with balanced macros should be approximately equal")
        void calcPercents_withBalancedMacros_shouldBeApproximatelyEqual() {
            MacroProcentsCalculator.MacroPercents result = MacroProcentsCalculator.calcPercentsSumOne(50, 150, 100);

            // Fat: 50*9 = 450 cal, Carbs: 150*4 = 600 cal, Protein: 100*4 = 400 cal
            // Total: 1450 cal
            // Fat%: 450/1450 = 0.31, Carbs%: 600/1450 = 0.41, Protein%: 400/1450 = 0.28

            assertTrue(result.fatPercent() > 0.30 && result.fatPercent() < 0.32);
            assertTrue(result.carbsPercent() > 0.40 && result.carbsPercent() < 0.42);
            assertTrue(result.proteinPercent() > 0.27 && result.proteinPercent() < 0.29);
        }

        @Test
        @DisplayName("calcPercents with typical macros should be accurate")
        void calcPercents_withTypicalMacros_shouldBeAccurate() {
            // Typical diet: 65g fat, 225g carbs, 150g protein
            MacroProcentsCalculator.MacroPercents result = MacroProcentsCalculator.calcPercentsSumOne(65, 225, 150);

            // Fat: 65*9 = 585, Carbs: 225*4 = 900, Protein: 150*4 = 600
            // Total: 2085
            // Fat: 28%, Carbs: 43%, Protein: 29%

            assertEquals(0.28, result.fatPercent(), 0.01);
            assertEquals(0.43, result.carbsPercent(), 0.01);
            assertEquals(0.29, result.proteinPercent(), 0.01);
        }
    }

    @Nested
    @DisplayName("Edge Cases")
    class EdgeCaseTests {

        @Test
        @DisplayName("calcPercents with only fat should return 1.0 fat, 0 others")
        void calcPercents_withOnlyFat_shouldReturn100PercentFat() {
            MacroProcentsCalculator.MacroPercents result = MacroProcentsCalculator.calcPercentsSumOne(50, 0, 0);

            assertEquals(1.0, result.fatPercent(), 0.01);
            assertEquals(0.0, result.carbsPercent());
            assertEquals(0.0, result.proteinPercent());
        }

        @Test
        @DisplayName("calcPercents with only carbs should return 1.0 carbs, 0 others")
        void calcPercents_withOnlyCarbs_shouldReturn100PercentCarbs() {
            MacroProcentsCalculator.MacroPercents result = MacroProcentsCalculator.calcPercentsSumOne(0, 150, 0);

            assertEquals(0.0, result.fatPercent());
            assertEquals(1.0, result.carbsPercent(), 0.01);
            assertEquals(0.0, result.proteinPercent());
        }

        @Test
        @DisplayName("calcPercents with only protein should return 1.0 protein, 0 others")
        void calcPercents_withOnlyProtein_shouldReturn100PercentProtein() {
            MacroProcentsCalculator.MacroPercents result = MacroProcentsCalculator.calcPercentsSumOne(0, 0, 100);

            assertEquals(0.0, result.fatPercent());
            assertEquals(0.0, result.carbsPercent());
            assertEquals(1.0, result.proteinPercent(), 0.01);
        }

        @Test
        @DisplayName("calcPercents with very small values should still sum to 1.0")
        void calcPercents_withSmallValues_shouldStillSumToOne() {
            MacroProcentsCalculator.MacroPercents result = MacroProcentsCalculator.calcPercentsSumOne(0.1, 0.1, 0.1);

            double sum = result.fatPercent() + result.carbsPercent() + result.proteinPercent();

            assertEquals(1.0, sum, 0.001);
        }

        @Test
        @DisplayName("calcPercents with large values should handle correctly")
        void calcPercents_withLargeValues_shouldHandleCorrectly() {
            MacroProcentsCalculator.MacroPercents result = MacroProcentsCalculator.calcPercentsSumOne(500, 1000, 800);

            double sum = result.fatPercent() + result.carbsPercent() + result.proteinPercent();

            assertEquals(1.0, sum, 0.001);
        }
    }

    @Nested
    @DisplayName("Rounding and Precision Tests")
    class RoundingTests {

        @Test
        @DisplayName("calcPercents should round to 2 decimal places")
        void calcPercents_shouldRoundTo2Decimals() {
            MacroProcentsCalculator.MacroPercents result = MacroProcentsCalculator.calcPercentsSumOne(33.33, 33.33, 33.33);

            // Each should be close to 0.33 or 0.34
            assertTrue(result.fatPercent().toString().matches("0\\.[0-9]{2}"));
            assertTrue(result.carbsPercent().toString().matches("0\\.[0-9]{2}"));
            assertTrue(result.proteinPercent().toString().matches("0\\.[0-9]{2}"));
        }

        @Test
        @DisplayName("calcPercents should not have precision errors")
        void calcPercents_shouldNotHavePrecisionErrors() {
            for (int i = 0; i < 100; i++) {
                MacroProcentsCalculator.MacroPercents result = MacroProcentsCalculator.calcPercentsSumOne(
                        Math.random() * 100,
                        Math.random() * 100,
                        Math.random() * 100
                );

                double sum = result.fatPercent() + result.carbsPercent() + result.proteinPercent();

                // Should always sum to 1.0 with small tolerance
                assertEquals(1.0, sum, 0.001, "Failed at iteration " + i);
            }
        }

        @Test
        @DisplayName("calcPercents with fractional inputs should handle rounding")
        void calcPercents_withFractionalInputs_shouldHandleRounding() {
            MacroProcentsCalculator.MacroPercents result = MacroProcentsCalculator.calcPercentsSumOne(25.5, 100.25, 75.75);

            double sum = result.fatPercent() + result.carbsPercent() + result.proteinPercent();

            assertEquals(1.0, sum, 0.001);
        }
    }

    @Nested
    @DisplayName("Real-World Scenarios")
    class RealWorldScenarios {

        @Test
        @DisplayName("High-protein diet macros (bodybuilding)")
        void calcPercents_highProteinDiet() {
            // Bodybuilder diet: 80g fat, 200g carbs, 200g protein
            MacroProcentsCalculator.MacroPercents result = MacroProcentsCalculator.calcPercentsSumOne(80, 200, 200);

            double sum = result.fatPercent() + result.carbsPercent() + result.proteinPercent();

            assertEquals(1.0, sum, 0.001);
            // Protein should be high (around 33%)
            assertTrue(result.proteinPercent() > 0.30);
        }

        @Test
        @DisplayName("Low-carb diet macros (keto)")
        void calcPercents_lowCarbDiet() {
            // Keto diet: 120g fat, 30g carbs, 100g protein
            MacroProcentsCalculator.MacroPercents result = MacroProcentsCalculator.calcPercentsSumOne(120, 30, 100);

            double sum = result.fatPercent() + result.carbsPercent() + result.proteinPercent();

            assertEquals(1.0, sum, 0.001);
            // Fat should be very high (around 65-70%)
            assertTrue(result.fatPercent() > 0.60);
            // Carbs should be very low (around 5%)
            assertTrue(result.carbsPercent() < 0.10);
        }

        @Test
        @DisplayName("Low-fat diet macros (vegan)")
        void calcPercents_lowFatDiet() {
            // Vegan diet: 40g fat, 350g carbs, 80g protein
            MacroProcentsCalculator.MacroPercents result = MacroProcentsCalculator.calcPercentsSumOne(40, 350, 80);

            double sum = result.fatPercent() + result.carbsPercent() + result.proteinPercent();

            assertEquals(1.0, sum, 0.001);
            // Carbs should dominate (around 70%)
            assertTrue(result.carbsPercent() > 0.65);
        }

        @Test
        @DisplayName("Balanced macros (50-30-20 rule)")
        void calcPercents_balancedMacros_5030_20() {
            // 2000 calorie diet: 50% carbs, 30% protein, 20% fat
            // Carbs: 250g (1000 cal), Protein: 150g (600 cal), Fat: 44g (400 cal)
            MacroProcentsCalculator.MacroPercents result = MacroProcentsCalculator.calcPercentsSumOne(44, 250, 150);

            assertEquals(1.0, result.fatPercent() + result.carbsPercent() + result.proteinPercent(), 0.001);
            assertEquals(0.20, result.fatPercent(), 0.02);
            assertEquals(0.30, result.proteinPercent(), 0.02);
            assertEquals(0.50, result.carbsPercent(), 0.02);
        }
    }
}