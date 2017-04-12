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
 
computeWord :: Int -> Distribution -> IO String
computeWord length dist@(Distribution order d) = computeWord' length (take order $ repeat '^') dist 

computeWord' :: Int -> String -> Distribution -> IO String
computeWord' 0 w _ = return w
computeWord' l w dist@(Distribution o d) = do
    let endOfWord        = reverse (take (o) $ reverse w)
        potentialLetters = Map.toList $ Map.filterWithKey (\ k _ -> init k == endOfWord) d
        sorted           = sortBy (\ c p -> if (snd c) > (snd p) then GT else LT) potentialLetters
        total            = foldr (\ v a -> a + (snd v)) 0 sorted

    --putStrLn $ "potential letter : " ++ show potentialLetters
    --putStrLn $ "current word : " ++ show w
    --putStrLn $ "computed end of word : " ++ show endOfWord

    letter <- computeLetter 0 total sorted

    computeWord' (l - 1) (w ++ letter) dist

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
    
    let wordLength = read $ args !! 0 :: Int
        order      = read $ args !! 1 :: Int
	file       = args !! 2
    handle <- openFile file ReadMode
    contents <- hGetContents handle
    
    let distribution = computeDistribution order (lines contents)

    toFile distribution "distribution_prenoms.txt"
    --distribution <- fromFile "distribution_prenoms.txt"

    --let distribution = computeDistribution 2 dictionary

    word <- computeWord (read (args !! 0)) distribution

    putStrLn word
