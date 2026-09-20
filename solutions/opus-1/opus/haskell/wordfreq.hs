import qualified Data.ByteString.Char8 as B
import qualified Data.Map.Strict as M
import Data.Char (isAsciiUpper, isAsciiLower, toLower)
import Data.List (sortBy)
import Data.Ord (comparing, Down(..))

isLetter' :: Char -> Bool
isLetter' c = isAsciiUpper c || isAsciiLower c

main :: IO ()
main = do
  s <- B.getContents
  let ws = filter (not . B.null) (B.splitWith (not . isLetter') s)
      m = M.fromListWith (+) [(B.map toLower w, 1 :: Int) | w <- ws]
      sorted = sortBy (comparing (\(w, c) -> (Down c, w))) (M.toList m)
  B.putStr (B.unlines [B.concat [w, B.pack " ", B.pack (show c)] | (w, c) <- sorted])
