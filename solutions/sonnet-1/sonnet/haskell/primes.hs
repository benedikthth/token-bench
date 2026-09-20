import Data.Array.ST
import Data.Array.Unboxed
import Control.Monad
import Control.Monad.ST
import Data.List (intercalate)

primesUpTo :: Int -> [Int]
primesUpTo n
  | n < 2 = []
  | otherwise = [i | i <- [2 .. n], arr ! i]
  where
    arr :: UArray Int Bool
    arr = runSTUArray $ do
      a <- newArray (0, n) True :: ST s (STUArray s Int Bool)
      writeArray a 0 False
      when (n >= 1) $ writeArray a 1 False
      forM_ [2 .. floor (sqrt (fromIntegral n :: Double))] $ \p -> do
        isPrime <- readArray a p
        when isPrime $
          forM_ [p * p, p * p + p .. n] $ \m -> writeArray a m False
      return a

main :: IO ()
main = do
  s <- getContents
  let n = read (head (words s)) :: Int
  putStrLn (intercalate " " (map show (primesUpTo n)))
