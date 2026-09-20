import Data.List (sort, sortBy, groupBy)
import Data.Ord (comparing)
import Data.Function (on)

main :: IO ()
main = do
  contents <- getContents
  let ws = lines contents
      ws' = filter (not . null) ws
      keyed = [(sort w, w) | w <- ws']
      sorted = sortBy (comparing fst) keyed
      groups = groupBy ((==) `on` fst) sorted
      groupWords = map (sort . map snd) groups
      groupsSorted = sortBy (comparing head) groupWords
  mapM_ (putStrLn . unwords) groupsSorted
