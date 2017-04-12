module Main where

import Distribution

import qualified Data.Map as Map
import Data.List
import System.IO
import System.Random
import System.Environment

dictionary = [ "maxime"
             , "roxanne"
             , "zoé"
             , "nathalie"
             , "mandy"
             , "inès"
             , "loan"
             , "guillaume"
             , "johan"
             , "marvin"
             , "emmanuel"
             , "mathieu"
             , "antoine"
             ]

computeWord :: Int -> Int -> String -> Distribution -> IO String
computeWord _ 0 w _ = return w
computeWord o l w d = do
    let endOfWord        = reverse (take (o) $ reverse w)
        potentialLetters = Map.toList $ Map.filterWithKey (\ k _ -> init k == endOfWord) d
        sorted           = sortBy (\ c p -> if (snd c) > (snd p) then GT else LT) potentialLetters
        total            = foldr (\ v a -> a + (snd v)) 0 sorted

    --putStrLn $ "potential letter : " ++ show potentialLetters
    --putStrLn $ "current word : " ++ show w
    --putStrLn $ "computed end of word : " ++ show endOfWord

    letter <- computeLetter 0 total sorted

    computeWord o (l - 1) (w ++ letter) d

computeLetter :: Int -> Int -> [(String, Int)] -> IO String
computeLetter _ _ [] = return ""
computeLetter prev total (d:dist) = do
    
    rnd <- randomRIO (0, 1) :: IO Float

    -- putStrLn $ "prev value is : " ++ show prev
    -- putStrLn $ "random number is : " ++ show rnd

    let curr  = snd d  
        cumul = prev + curr
        rnd'  = floor (rnd * fromIntegral(total))

    -- putStrLn $ "cumul is : " ++ show cumul
    -- putStrLn $ "random number prime is : " ++ show rnd'

    if rnd' < cumul 
    then return $ [last . fst $ d]
    else computeLetter cumul total dist

main = do
    args <- getArgs
    --handle <- openFile "communes.txt" ReadMode
    --contents <- hGetContents handle
    
    --let distribution = computeDistribution 2 (lines contents)

    --toFile distribution "distribution.txt"
    --distribution <- fromFile "distribution.txt"

    let distribution = computeDistribution 2 dictionary

    word <- computeWord 2 (read (args !! 0)) "^^" distribution

    putStrLn word
