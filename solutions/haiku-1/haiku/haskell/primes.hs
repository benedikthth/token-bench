import Data.List (intercalate)

sieve :: Int -> [Int]
sieve n
  | n < 2 = []
  | otherwise = go [2..n]
  where
    go [] = []
    go (p:xs) = p : go [x | x <- xs, x `mod` p /= 0]

main :: IO ()
main = do
  n <- readLn
  let primes = sieve n
  putStrLn (intercalate " " (map show primes))
