package fr.busmaxime.pcg.word.generator;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Random;

public class Main {

    public static void main(String[] args) {
        StringBuilder word = new StringBuilder();
        Random random = new Random();
        ArrayList<CharacterAndItsProbability> distribution = new ArrayList<>();
        distribution.add(new CharacterAndItsProbability("a", BigDecimal.valueOf(0.5)));
        distribution.add(new CharacterAndItsProbability("b", BigDecimal.valueOf(0.3)));
        distribution.add(new CharacterAndItsProbability("c", BigDecimal.valueOf(0.2)));

        for (int i = 0; i < 100; i++) {
            String character = CharacterRandomizer.chooseRandomly(distribution, BigDecimal.valueOf(random.nextDouble()));

            word.append(character);
        }

        System.out.println(word.toString());
    }
}
