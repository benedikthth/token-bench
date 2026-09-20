{-# LANGUAGE BangPatterns #-}
module Main where

import qualified Data.ByteString.Char8 as B
import qualified Data.IntMap.Strict as IM
import qualified Data.Set as S
import Data.Array (Array, accumArray, (!))
import Data.Maybe (fromJust)

readInts :: B.ByteString -> [Int]
readInts s = case B.readInt (B.dropWhile (`elem` " \t\r\n") s) of
  Nothing -> []
  Just (x, rest) -> x : readInts rest

main :: IO ()
main = do
  inp <- B.getContents
  let ws = readInts inp
  case ws of
    (n : m : rest) -> do
      let (edgeWords, rest') = splitAt (3 * m) rest
          edges = go edgeWords
            where
              go (u : v : w : xs) = (u, (v, w)) : (v, (u, w)) : go xs
              go _ = []
          adj :: Array Int [(Int, Int)]
          adj = accumArray (flip (:)) [] (0, max 0 (n - 1)) edges
          (s, t) = case rest' of
            (a : b : _) -> (a, b)
            _ -> (0, 0)
      if s == t
        then putStrLn "0"
        else if n <= 0 || s < 0 || s >= n || t < 0 || t >= n
          then putStrLn "-1"
          else putStrLn (maybe "-1" show (dijkstra adj s t))
    _ -> putStrLn "-1"

dijkstra :: Array Int [(Int, Int)] -> Int -> Int -> Maybe Int
dijkstra adj s t = loop (S.singleton (0, s)) (IM.singleton s 0)
  where
    loop !pq !dist = case S.minView pq of
      Nothing -> Nothing
      Just ((d, u), pq')
        | u == t -> Just d
        | d > IM.findWithDefault maxBound u dist -> loop pq' dist
        | otherwise ->
            let (pq'', dist') = foldr relax (pq', dist) (adj ! u)
                relax (v, w) (q, dm) =
                  let nd = d + w
                   in case IM.lookup v dm of
                        Just old | old <= nd -> (q, dm)
                        _ -> (S.insert (nd, v) q, IM.insert v nd dm)
             in loop pq'' dist'
