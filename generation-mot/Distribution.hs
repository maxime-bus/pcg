module Distribution 
( Distribution 

, computeDistribution
, toFile
, fromFile
) where

import qualified Data.Map as Map
import System.IO

type Distribution = (Map.Map CharacterPair Integer)
type CharacterPair = (Char, Char)

computeDistribution :: [String] -> Distribution
computeDistribution = foldr (computeStatisticsOnWord) Map.empty 

computeStatisticsOnWord :: String -> Distribution -> Distribution
computeStatisticsOnWord [] _ = Map.empty
computeStatisticsOnWord (c:chars) d = computeStatisticsOnWord' chars (updateCharacterPair ('^', c) d)

computeStatisticsOnWord' :: String -> Distribution -> Distribution
computeStatisticsOnWord' [] d = d
computeStatisticsOnWord' [c] d = updateCharacterPair (c, '$') d
computeStatisticsOnWord' (c1:c2:chars) d = let d' = updateCharacterPair (c1, c2) d
                                           in computeStatisticsOnWord' (c2:chars) d'

updateCharacterPair :: CharacterPair -> Distribution -> Distribution
updateCharacterPair pair d = Map.insertWith (\ newValue oldValue -> newValue + oldValue) pair 1 d

toFile :: Distribution -> FilePath -> IO ()
toFile d path = do

    let content = unlines $ map (\ ((a, b), c) -> a:b:" " ++ (show c)) $ Map.toList d

    writeFile path content

fromFile :: FilePath -> IO (Distribution)
fromFile path = do
    content <- fmap (lines) $ readFile path

    return $ foldr (\ (c1:c2:_:number) m -> Map.insert (c1, c2) (read number) m) Map.empty content
