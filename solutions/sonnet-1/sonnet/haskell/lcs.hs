import Control.Monad
import Control.Monad.ST
import Data.Array.ST
import Data.Array.Unboxed
import qualified Data.ByteString.Char8 as BS

main :: IO ()
main = do
  contents <- BS.getContents
  let ls = BS.lines contents
      a = case ls of (x:_) -> x; [] -> BS.empty
      b = case ls of (_:y:_) -> y; _ -> BS.empty
  print (lcs a b)

lcs :: BS.ByteString -> BS.ByteString -> Int
lcs a b = runST $ do
  let n = BS.length a
      m = BS.length b
      aArr = listArray (0, n-1) (BS.unpack a) :: UArray Int Char
      bArr = listArray (0, m-1) (BS.unpack b) :: UArray Int Char
  prev <- newArray (0, m) 0 :: ST s (STUArray s Int Int)
  curr <- newArray (0, m) 0 :: ST s (STUArray s Int Int)
  forM_ [0 .. n-1] $ \i -> do
    let ai = aArr ! i
    forM_ [0 .. m-1] $ \j -> do
      let bj = bArr ! j
      if ai == bj
        then do
          d <- readArray prev j
          writeArray curr (j+1) (d + 1)
        else do
          up <- readArray prev (j+1)
          left <- readArray curr j
          writeArray curr (j+1) (max up left)
    forM_ [0 .. m] $ \j -> readArray curr j >>= writeArray prev j
  readArray prev m
