module Main where

import Distribution

import qualified Data.Map as Map
import Data.List
import System.IO
import System.Random
import System.Environment

computeWord :: Int -> Distribution -> IO String
computeWord length dist@(Distribution order d) = fmap (drop order) $ computeWord' length (take order $ repeat '^') dist 

computeWord' :: Int -> String -> Distribution -> IO String
computeWord' 0 w _ = return w
computeWord' l w dist@(Distribution o d) = do
    let endOfWord        = reverse (take (o) $ reverse w)
        potentialLetters = Map.toList $ Map.filterWithKey (\ k _ -> init k == endOfWord) d
        sorted           = sortBy (\ c p -> if (snd c) > (snd p) then GT else LT) potentialLetters
        total            = foldr (\ v a -> a + (snd v)) 0 sorted

    letter <- computeLetter 0 total sorted

    computeWord' (l - 1) (w ++ letter) dist

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

main = do
    (command:args) <- getArgs

    let (Just action) = lookup command dispatch

    action args

-- Code based on http://learnyouahaskell.com/input-and-output#command-line-arguments 
dispatch :: [(String, [String] -> IO ())]
dispatch = [ ("generateDistribution", generateDistributionFile)
           , ("generateWord", generateWord)
           ]

generateDistributionFile :: [String] -> IO ()
generateDistributionFile [path, order] = do
    handle <- openFile path ReadMode
    contents <- hGetContents handle

    let distribution = computeDistribution (read order) (lines contents)

    toFile distribution (path ++ ".dist")

generateWord :: [String] -> IO ()
generateWord [distributionPath, wordLength] = do
    distribution <- fromFile distributionPath

    word <- computeWord (read wordLength) distribution

    putStrLn word
