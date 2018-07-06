package fr.busmaxime.pcg.word.generator;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

public class CharacterRandomizer {
    public static String chooseRandomly(ArrayList<CharacterAndItsProbability> distribution, BigDecimal randomNumber) {
        BigDecimal cumulativeProbability = BigDecimal.ZERO;

        List<CharacterAndItsProbability> distributionSortedByLesserProbability = distribution.stream().sorted().collect(Collectors.toList());

        for (CharacterAndItsProbability characterAndProbability : distributionSortedByLesserProbability) {
            cumulativeProbability = cumulativeProbability.add(characterAndProbability.getProbability());

            if (randomNumber.compareTo(cumulativeProbability) <= 0) {
                return characterAndProbability.getCharacter();
            }
        }

        return "";
    }
}
