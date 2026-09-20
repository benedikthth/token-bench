import qualified Data.Map.Strict as M
import Data.List (sort)

main :: IO ()
main = do
    contents <- getContents
    let ws = filter (not . null) (map (filter (/= '\r')) (lines contents))
        groups = M.fromListWith (flip (++)) [(sort w, [w]) | w <- ws]
        sortedGroups = sort (map sort (M.elems groups))
    mapM_ (putStrLn . unwords) sortedGroups
