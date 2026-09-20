import Data.List (sortBy)
import Data.Ord (Down(..), comparing)
import Data.Char (toLower)
import Data.Map (Map)
import qualified Data.Map as Map

isAsciiLetter :: Char -> Bool
isAsciiLetter c = (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z')

main :: IO ()
main = do
  input <- getContents
  let words = extractWords input
      wordCounts = countWords words
      sorted = sortResults wordCounts
  mapM_ printResult sorted

extractWords :: String -> [String]
extractWords [] = []
extractWords (c:cs)
  | isAsciiLetter c = let (word, rest) = span isAsciiLetter (c:cs)
                      in map toLower word : extractWords rest
  | otherwise = extractWords cs

countWords :: [String] -> Map String Int
countWords = foldr (\w acc -> Map.insertWith (+) w 1 acc) Map.empty

sortResults :: Map String Int -> [(String, Int)]
sortResults m = sortBy (comparing (\(w, c) -> (Down c, w))) (Map.toList m)

printResult :: (String, Int) -> IO ()
printResult (word, count) = putStrLn $ word ++ " " ++ show count
