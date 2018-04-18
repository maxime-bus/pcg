module Generator where

import Distribution

import qualified Data.Map as Map
import Data.List
import System.Random

computeWord :: Distribution -> IO String
computeWord dist@(Distribution order _) = fmap (init . drop order) $ computeWord' (take order $ repeat '^') dist 
computeWord' :: String -> Distribution -> IO String
computeWord' w dist@(Distribution o d) 
    | last w == '$' = return w
    | otherwise     = do
        let endOfWord        = reverse (take (o) $ reverse w)
            potentialLetters = Map.toList $ Map.filterWithKey (\ k _ -> init k == endOfWord) d
            sorted           = sortBy (\ c p -> if (snd c) > (snd p) then GT else LT) potentialLetters
            total            = foldr (\ v a -> a + (snd v)) 0 sorted

        letter <- computeLetter 0 total sorted

        computeWord' (w ++ letter) dist

computeLetter :: Int -> Int -> [(String, Int)] -> IO String
computeLetter _ _ [] = return ""
computeLetter prev total (d:dist) = do
    
    rnd <- randomRIO (0, 1) :: IO Float

    let curr  = snd d  
        cumul = prev + curr
        rnd'  = floor (rnd * fromIntegral(total))

    if rnd' < cumul 
    then return $ [last . fst $ d]
    else computeLetter cumul total dist
