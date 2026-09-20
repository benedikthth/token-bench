import qualified Data.ByteString.Char8 as B
import Data.Array.Unboxed
import Data.Char (isSpace)

readInts :: B.ByteString -> [Int]
readInts s = case B.readInt (B.dropWhile isSpace s) of
  Just (x, rest) -> x : readInts rest
  Nothing -> []

main :: IO ()
main = do
  input <- B.getContents
  let (r:c:rest) = readInts input
      arr = listArray (0, r * c - 1) (take (r * c) rest ++ repeat 0) :: UArray Int Int
      line j = B.unwords [B.pack (show (arr ! (i * c + j))) | i <- [0 .. r - 1]]
  B.putStr (B.unlines [line j | j <- [0 .. c - 1]])
