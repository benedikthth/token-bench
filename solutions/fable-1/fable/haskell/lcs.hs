{-# LANGUAGE BangPatterns #-}
module Main (main) where

import qualified Data.ByteString.Char8 as B
import Data.Array.ST (newArray, readArray, writeArray, runSTUArray)
import Data.Array.Unboxed (UArray, (!))
import Control.Monad (forM_, when)
import Control.Monad.ST (ST)
import Data.Array.ST (STUArray)

stripCR :: B.ByteString -> B.ByteString
stripCR s = B.filter (\c -> c /= '\r' && c /= '\n') s

lcsLen :: B.ByteString -> B.ByteString -> Int
lcsLen a b
  | n == 0 || m == 0 = 0
  | otherwise = table ! m
  where
    n = B.length a
    m = B.length b
    table :: UArray Int Int
    table = runSTUArray $ do
      prev <- newArray (0, m) 0 :: ST s (STUArray s Int Int)
      cur  <- newArray (0, m) 0 :: ST s (STUArray s Int Int)
      forM_ [1 .. n] $ \i -> do
        let ai = B.index a (i - 1)
        writeArray cur 0 0
        forM_ [1 .. m] $ \j -> do
          if B.index b (j - 1) == ai
            then do
              d <- readArray prev (j - 1)
              writeArray cur j (d + 1)
            else do
              u <- readArray prev j
              l <- readArray cur (j - 1)
              writeArray cur j (max u l)
        -- copy cur into prev
        forM_ [0 .. m] $ \j -> readArray cur j >>= writeArray prev j
      when False (return ())
      return prev

main :: IO ()
main = do
  contents <- B.getContents
  let ls = B.split '\n' contents
      get k = if k < length ls then stripCR (ls !! k) else B.empty
      a = get 0
      b = get 1
  print (lcsLen a b)
