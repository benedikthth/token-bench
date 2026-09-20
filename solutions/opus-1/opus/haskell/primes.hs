import Data.Array.ST
import Data.Array.Unboxed
import Control.Monad

sieve :: Int -> UArray Int Bool
sieve n = runSTUArray $ do
  arr <- newArray (0, max n 1) True
  writeArray arr 0 False
  writeArray arr 1 False
  forM_ (takeWhile (\i -> i * i <= n) [2 ..]) $ \i -> do
    p <- readArray arr i
    when p $ forM_ [i * i, i * i + i .. n] $ \j -> writeArray arr j False
  return arr

main :: IO ()
main = do
  s <- getContents
  let n = read (head (words s)) :: Int
      a = sieve n
  putStrLn $ unwords [show i | i <- [2 .. n], a ! i]
