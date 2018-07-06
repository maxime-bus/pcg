package fr.busmaxime.pcg.word.generator;

import java.math.BigDecimal;

public class CharacterAndItsProbability implements Comparable<CharacterAndItsProbability> {

    private final String character;
    private final BigDecimal probability;

    public CharacterAndItsProbability(String character, BigDecimal probability) {
        this.character = character;
        this.probability = probability;
    }

    public String getCharacter() {
        return character;
    }

    public BigDecimal getProbability() {
        return probability;
    }

    @Override
    public int compareTo(CharacterAndItsProbability o) {
        return this.probability.compareTo(o.probability);
    }
}
