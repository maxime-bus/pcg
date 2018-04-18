module Main where

import Distribution
import Generator

import System.IO
import System.Environment

main = do
    (command:args) <- getArgs

    let (Just action) = lookup command dispatch

    action args

-- Code based on http://learnyouahaskell.com/input-and-output#command-line-arguments 
dispatch :: [(String, [String] -> IO ())]
dispatch = [ ("genDist", generateDistributionFile)
           , ("genWord", generateWord)
           ]

generateDistributionFile :: [String] -> IO ()
generateDistributionFile [path, order] = do
    handle <- openFile path ReadMode
    contents <- hGetContents handle

    let distribution = computeDistribution (read order) (lines contents)

    toFile distribution (path ++ ".dist")

generateWord :: [String] -> IO ()
generateWord [distributionPath] = do
    distribution <- fromFile distributionPath

    word <- computeWord distribution

    putStrLn word
