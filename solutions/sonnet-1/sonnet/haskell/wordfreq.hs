import Data.Char (isAlpha, toLower, isAscii)
import Data.List (sortBy)
import Data.Ord (comparing)
import qualified Data.Map.Strict as M

isWordChar :: Char -> Bool
isWordChar c = isAscii c && isAlpha c

main :: IO ()
main = do
  input <- getContents
  let ws = words' input
      counts = M.fromListWith (+) [(map toLower w, 1 :: Int) | w <- ws]
      sorted = sortBy (\(w1, c1) (w2, c2) -> compare c2 c1 <> compare w1 w2) (M.toList counts)
  mapM_ (\(w, c) -> putStrLn (w ++ " " ++ show c)) sorted

words' :: String -> [String]
words' s = case dropWhile (not . isWordChar) s of
  "" -> []
  s' -> w : words' rest
    where (w, rest) = span isWordChar s'
