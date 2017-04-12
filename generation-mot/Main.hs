module Main where

import Distribution

import qualified Data.Map as Map
import Data.List
import System.IO
import System.Random
import System.Environment

-- dictionary = [ "maxime"
--              , "roxanne"
--              , "zoé"
--              , "nathalie"
--              , "mandy"
--              , "inès"
--              , "loan"
--              , "guillaume"
--              , "johan"
--              , "marvin"
--              , "emmanuel"
--              , "mathieu"
--              , "antoine"
--              ]

computeWord :: Integer -> String -> Distribution -> IO String
computeWord 0 w _ = return w
computeWord l w d = do
    let potentialLetters = Map.toList $ Map.filterWithKey (\ k _ -> fst k == head w) d
        sorted           = sortBy (\ c p -> if (snd c) > (snd p) then GT else LT) potentialLetters
        total            = foldr (\ v a -> a + (snd v)) 0 sorted

    letter <- computeLetter 0 total sorted

    computeWord (l - 1) (letter:w) d

computeLetter :: Integer -> Integer -> [((Char, Char), Integer)] -> IO Char
computeLetter _ _ [] = return ' '
computeLetter prev total (d:dist) = do
    
    rnd <- randomRIO (0, 1) :: IO Float

    -- putStrLn $ "prev value is : " ++ show prev
    -- putStrLn $ "random number is : " ++ show rnd

    let curr  = snd d  
        cumul = prev + curr
        rnd'  = floor (rnd * (fromInteger total))

    -- putStrLn $ "cumul is : " ++ show cumul
    -- putStrLn $ "random number prime is : " ++ show rnd'

    if rnd' < cumul 
    then return $ snd . fst $ d 
    else computeLetter cumul total dist

main = do
    args <- getArgs
    distribution <- fromFile "distribution.txt"

    word <- computeWord (read (args !! 0)) "^" distribution

    print $ reverse word
