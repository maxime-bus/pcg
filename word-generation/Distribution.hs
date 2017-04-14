module Distribution 
( Distribution(..) 
, computeDistribution
, toFile
, fromFile
) where

import qualified Data.Map as Map

type Order = Int
data Distribution = Distribution Order (Map.Map String Int)

computeDistribution :: Order -> [String] -> Distribution
computeDistribution order = foldr (computeStatisticsOnWord) (Distribution order Map.empty)

computeStatisticsOnWord :: String -> Distribution -> Distribution
computeStatisticsOnWord [] (Distribution order _) = Distribution order Map.empty
computeStatisticsOnWord w d@(Distribution order _) = 
    let w' = (take order $ repeat '^') ++ w
    in computeStatisticsOnWord' w' d

computeStatisticsOnWord' :: String -> Distribution -> Distribution
computeStatisticsOnWord' [] d = d
computeStatisticsOnWord' word dist@(Distribution order _)
    | length word == order = updateOccurence (word++"$") dist
    | otherwise            = let dist' = updateOccurence (take (order+1) word) dist
                             in computeStatisticsOnWord' (tail word) dist'

updateOccurence :: String -> Distribution -> Distribution
updateOccurence occurence (Distribution order d) = Distribution order d'
    where d' = Map.insertWith (\ newValue oldValue -> newValue + oldValue) occurence 1 d

toFile :: Distribution -> FilePath -> IO ()
toFile (Distribution order d) path = do
    let distStringified  = unlines $ map (\ (k, c) -> k ++ " " ++ (show c)) $ Map.toList d
        orderStringified = show order
        content          = orderStringified ++ "\n" ++ distStringified

    writeFile path content

fromFile :: FilePath -> IO (Distribution)
fromFile path = do
    content <- fmap (lines) $ readFile path
    
    let order = read $ head content :: Int
        d     = foldr (\ line m -> Map.insert (head $ words line) (read (last $ words line)) m) Map.empty (tail content)

    return $ Distribution order d
