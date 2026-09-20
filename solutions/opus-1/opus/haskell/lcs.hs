import qualified Data.ByteString.Char8 as B
import Data.Array.ST
import Data.Array.Unboxed
import Control.Monad
import Control.Monad.ST

lcs :: B.ByteString -> B.ByteString -> Int
lcs a b = runST $ do
  let n = B.length a
      m = B.length b
  prev <- newArray (0, m) 0 :: ST s (STUArray s Int Int)
  cur <- newArray (0, m) 0 :: ST s (STUArray s Int Int)
  let go p c i
        | i > n = readArray p m
        | otherwise = do
            let ca = B.index a (i - 1)
            writeArray c 0 0
            forM_ [1 .. m] $ \j -> do
              if ca == B.index b (j - 1)
                then do
                  d <- readArray p (j - 1)
                  writeArray c j (d + 1)
                else do
                  u <- readArray p j
                  l <- readArray c (j - 1)
                  writeArray c j (max u l)
            go c p (i + 1)
  go prev cur 1

main :: IO ()
main = do
  s <- B.getContents
  let ls = map (B.filter (/= '\r')) (B.lines s)
      a = if null ls then B.empty else head ls
      b = if length ls < 2 then B.empty else ls !! 1
  print (lcs a b)
