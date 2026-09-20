import Data.List (sort, sortBy, groupBy)
import Data.Function (on)

main :: IO ()
main = do
  input <- getContents
  let ws = lines input
      -- Pair each word with its canonical form (sorted characters)
      paired = [(sort w, w) | w <- ws]
      -- Sort by canonical form to group anagrams together
      sorted = sortBy (compare `on` fst) paired
      -- Group consecutive words with the same canonical form
      grouped = groupBy (\a b -> fst a == fst b) sorted
      -- Extract words from each group and sort them alphabetically
      groups = map (sort . map snd) grouped
      -- Sort groups by their first word
      result = sortBy (compare `on` head) groups
  mapM_ putStrLn (map unwords result)
