module Main where

import qualified Data.ByteString.Char8 as B
import qualified Data.Map.Strict as M
import Data.Char (isAsciiLower, isAsciiUpper, toLower)
import Data.List (sortBy)
import Data.Ord (comparing, Down(..))

isLetter' :: Char -> Bool
isLetter' c = isAsciiLower c || isAsciiUpper c

wordsOf :: B.ByteString -> [B.ByteString]
wordsOf s
  | B.null s = []
  | otherwise =
      let s' = B.dropWhile (not . isLetter') s
      in if B.null s'
           then []
           else let (w, rest) = B.span isLetter' s'
                in B.map toLower w : wordsOf rest

main :: IO ()
main = do
  input <- B.getContents
  let counts = M.fromListWith (+) [(w, 1 :: Int) | w <- wordsOf input]
      sorted = sortBy (comparing (Down . snd) <> comparing fst) (M.toList counts)
  B.putStr $ B.unlines [B.concat [w, B.pack " ", B.pack (show n)] | (w, n) <- sorted]
