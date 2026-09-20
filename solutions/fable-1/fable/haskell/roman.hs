module Main where

table :: [(Int, String)]
table =
  [ (1000, "M"), (900, "CM"), (500, "D"), (400, "CD")
  , (100, "C"), (90, "XC"), (50, "L"), (40, "XL")
  , (10, "X"), (9, "IX"), (5, "V"), (4, "IV"), (1, "I")
  ]

roman :: Int -> String
roman 0 = ""
roman n = case [(v, s) | (v, s) <- table, v <= n] of
  ((v, s) : _) -> s ++ roman (n - v)
  [] -> ""

main :: IO ()
main = interact $ unlines . map (roman . read) . filter (not . null) . map (filter (/= '\r')) . lines
