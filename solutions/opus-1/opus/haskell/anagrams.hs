import Data.List (sort)
import qualified Data.Map.Strict as M

main :: IO ()
main = do
  s <- getContents
  let ws = filter (not . null) (map (filter (`notElem` " \t\r")) (lines s))
      m = M.fromListWith (++) [(sort w, [w]) | w <- ws]
      groups = sort (map sort (M.elems m))
  mapM_ (putStrLn . unwords) groups
