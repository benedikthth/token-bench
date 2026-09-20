import Data.List (transpose)

main :: IO ()
main = do
  line1 <- getLine
  let [r, c] = map read (words line1) :: [Int]
  matrix <- sequence [getLine | _ <- [1..r]]
  let parsedMatrix = map (map read . words) matrix :: [[Int]]
  let transposed = transpose parsedMatrix
  mapM_ printRow transposed
  where
    printRow row = putStrLn (unwords (map show row))
