import qualified Data.ByteString.Char8 as B
import Data.List (transpose)
import Data.Maybe (fromJust)

main :: IO ()
main = do
  s <- B.getContents
  let ws = map (fst . fromJust . B.readInt) (B.words s)
      (r, c) = (head ws, ws !! 1)
      body = take (r * c) (drop 2 ws)
      rows = chunk c body
      out = transpose rows
  B.putStr (B.unlines (map (B.unwords . map (B.pack . show)) out))

chunk :: Int -> [Int] -> [[Int]]
chunk _ [] = []
chunk n xs = let (a, b) = splitAt n xs in a : chunk n b
