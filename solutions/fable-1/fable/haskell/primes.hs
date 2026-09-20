import Data.Array.ST
import Data.Array.Unboxed
import Control.Monad
import Control.Monad.ST

sieve :: Int -> UArray Int Bool
sieve n = runSTUArray $ do
  arr <- newArray (0, max 1 n) True
  writeArray arr 0 False
  writeArray arr 1 False
  forM_ [2 .. n] $ \i -> do
    isP <- readArray arr i
    when (isP && i * i <= n) $
      forM_ [i * i, i * i + i .. n] $ \j -> writeArray arr j False
  return arr

main :: IO ()
main = do
  s <- getContents
  let n = case words s of
            (w:_) -> read w
            _     -> 0
      arr = sieve n
      ps = [i | i <- [2 .. n], arr ! i]
  putStrLn (unwords (map show ps))
