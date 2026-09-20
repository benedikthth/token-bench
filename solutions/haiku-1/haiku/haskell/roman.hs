toRoman :: Int -> String
toRoman n = go n romanValues
  where
    romanValues = [(1000, "M"), (900, "CM"), (500, "D"), (400, "CD"),
                   (100, "C"), (90, "XC"), (50, "L"), (40, "XL"),
                   (10, "X"), (9, "IX"), (5, "V"), (4, "IV"), (1, "I")]

    go :: Int -> [(Int, String)] -> String
    go 0 _ = ""
    go _ [] = ""
    go num ((val, sym):rest) =
      let count = num `div` val
          remainder = num `mod` val
      in concat (replicate count sym) ++ go remainder rest

main :: IO ()
main = interact process
  where
    process = unlines . map toRoman . map read . lines
