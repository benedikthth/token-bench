main :: IO ()
main = interact (unlines . map (toRoman . read) . lines)

toRoman :: Int -> String
toRoman n = go n table
  where
    table =
      [ (1000, "M"), (900, "CM"), (500, "D"), (400, "CD")
      , (100, "C"), (90, "XC"), (50, "L"), (40, "XL")
      , (10, "X"), (9, "IX"), (5, "V"), (4, "IV"), (1, "I")
      ]
    go _ [] = ""
    go m ((v, s) : rest)
      | m >= v = s ++ go (m - v) ((v, s) : rest)
      | otherwise = go m rest
