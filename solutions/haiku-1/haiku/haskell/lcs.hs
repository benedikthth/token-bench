import Data.Array

longestCommonSubsequence :: String -> String -> Int
longestCommonSubsequence s1 s2 = table ! (m, n)
  where
    m = length s1
    n = length s2

    table = array ((0, 0), (m, n)) [((i, j), cell i j) | i <- [0..m], j <- [0..n]]

    cell 0 _ = 0
    cell _ 0 = 0
    cell i j
      | s1 !! (i-1) == s2 !! (j-1) = table ! (i-1, j-1) + 1
      | otherwise = max (table ! (i-1, j)) (table ! (i, j-1))

main :: IO ()
main = do
  line1 <- getLine
  line2 <- getLine
  print $ longestCommonSubsequence line1 line2
