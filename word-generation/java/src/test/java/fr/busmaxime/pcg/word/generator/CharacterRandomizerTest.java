package fr.busmaxime.pcg.word.generator;

import org.junit.Before;
import org.junit.Test;

import java.math.BigDecimal;
import java.util.ArrayList;

import static org.assertj.core.api.Assertions.assertThat;

public class CharacterRandomizerTest {

    private ArrayList<CharacterAndItsProbability> distribution;

    @Before
    public void setUp() throws Exception {
        distribution = new ArrayList<>();
    }

    @Test
    public void shouldReturnEmptyCharacterWhenNoProbabilitiesAreGiven() {
        assertThat(CharacterRandomizer.chooseRandomly(distribution, BigDecimal.valueOf(0.5))).isEmpty();
    }

    @Test
    public void shouldReturnCharacterIfProbabilityisOne() {
        distribution.add(new CharacterAndItsProbability("a", BigDecimal.ONE));

        assertThat(CharacterRandomizer.chooseRandomly(distribution, BigDecimal.valueOf(0.5))).isEqualTo("a");
    }

    @Test
    public void shouldReturnCharacterBasedOnCumulativeProbabilities() {
        distribution.add(new CharacterAndItsProbability("a", BigDecimal.valueOf(0.5)));
        distribution.add(new CharacterAndItsProbability("b", BigDecimal.valueOf(0.3)));
        distribution.add(new CharacterAndItsProbability("c", BigDecimal.valueOf(0.2)));

        assertThat(CharacterRandomizer.chooseRandomly(distribution, BigDecimal.valueOf(1))).isEqualTo("a");
        assertThat(CharacterRandomizer.chooseRandomly(distribution, BigDecimal.valueOf(0.9))).isEqualTo("a");
        assertThat(CharacterRandomizer.chooseRandomly(distribution, BigDecimal.valueOf(0.8))).isEqualTo("a");
        assertThat(CharacterRandomizer.chooseRandomly(distribution, BigDecimal.valueOf(0.7))).isEqualTo("a");
        assertThat(CharacterRandomizer.chooseRandomly(distribution, BigDecimal.valueOf(0.6))).isEqualTo("a");
        assertThat(CharacterRandomizer.chooseRandomly(distribution, BigDecimal.valueOf(0.5))).isEqualTo("b");
        assertThat(CharacterRandomizer.chooseRandomly(distribution, BigDecimal.valueOf(0.4))).isEqualTo("b");
        assertThat(CharacterRandomizer.chooseRandomly(distribution, BigDecimal.valueOf(0.3))).isEqualTo("b");
        assertThat(CharacterRandomizer.chooseRandomly(distribution, BigDecimal.valueOf(0.2))).isEqualTo("c");
        assertThat(CharacterRandomizer.chooseRandomly(distribution, BigDecimal.valueOf(0.1))).isEqualTo("c");
        assertThat(CharacterRandomizer.chooseRandomly(distribution, BigDecimal.valueOf(0))).isEqualTo("c");
    }
}
