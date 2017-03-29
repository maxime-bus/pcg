module Main where

import System.Random
import System.Environment
import Control.Applicative
import Data.List

main = do
    args <- getArgs
    let number = read $ head args :: Int
    result <- fn (take number $ repeat 0) 10
    putStrLn $ toCsv result

fn :: [Integer] -> Integer -> IO ([Integer])
fn [] _ = fmap(:[]) $ randomRIO (0, 10)
fn [a] _ = fmap(:[]) $ randomRIO (0, 10)
fn values remainingDivision = let (l1, l2) = cutInHalf values
                                  division = remainingDivision - 1
                              in (++) <$> (fn l1 division) <*> (fn l2 division)

cutInHalf :: [Integer] -> ([Integer], [Integer])
cutInHalf list = splitAt (length list `div` 2) list

changeLastValue :: [a] -> a -> [a]
changeLastValue list value = init list ++ [value]

toCsv :: [Integer] -> String
toCsv list = foldl toString "" $ zipWith (,) [0,1..] list

toString :: String -> (Integer, Integer) -> String
toString acc (x, y) = acc ++ show x ++ " " ++ show y ++ "\n"
