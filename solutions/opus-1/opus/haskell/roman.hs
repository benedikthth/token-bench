main :: IO ()
main = interact $ unlines . map (roman . read) . words

roman :: Int -> String
roman 0 = ""
roman n = s ++ roman (n - v)
  where
    (v, s) = head [p | p@(x, _) <- table, x <= n]

table :: [(Int, String)]
table =
  [ (1000, "M"), (900, "CM"), (500, "D"), (400, "CD")
  , (100, "C"), (90, "XC"), (50, "L"), (40, "XL")
  , (10, "X"), (9, "IX"), (5, "V"), (4, "IV"), (1, "I")
  ]
