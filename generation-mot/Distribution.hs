module Distribution 
( Distribution 

, computeDistribution
, toFile
, fromFile
) where

import qualified Data.Map as Map
import System.IO

type Distribution = (Map.Map String Int)

computeDistribution :: Int -> [String] -> Distribution
computeDistribution order = foldr (computeStatisticsOnWord order) Map.empty 

computeStatisticsOnWord :: Int -> String -> Distribution -> Distribution
computeStatisticsOnWord _ [] _ = Map.empty
computeStatisticsOnWord order w d = 
    let w' = (take order $ repeat '^') ++ w
    in computeStatisticsOnWord' (order+1) w' d

computeStatisticsOnWord' :: Int -> String -> Distribution -> Distribution
computeStatisticsOnWord' _ [] d = d
computeStatisticsOnWord' order word d
    | length word == order = updateCharacterPair word d
    | otherwise            = let d' = updateCharacterPair (take order word) d
                             in computeStatisticsOnWord' order (tail word) d'
                             

updateCharacterPair :: String -> Distribution -> Distribution
updateCharacterPair pair d = Map.insertWith (\ newValue oldValue -> newValue + oldValue) pair 1 d

toFile :: Distribution -> FilePath -> IO ()
toFile d path = do

    let content = unlines $ map (\ (k, c) -> k ++ " " ++ (show c)) $ Map.toList d

    writeFile path content

fromFile :: FilePath -> IO (Distribution)
fromFile path = do
    content <- fmap (lines) $ readFile path

    return $ foldr (\ line m -> Map.insert (head $ words line) (read (last $ words line)) m) Map.empty content
