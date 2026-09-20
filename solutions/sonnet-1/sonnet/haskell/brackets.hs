main :: IO ()
main = interact (unlines . map (result . check []) . lines)
  where
    result True = "yes"
    result False = "no"

    check :: [Char] -> String -> Bool
    check stack [] = null stack
    check stack (c:cs)
      | c `elem` "([{" = check (c : stack) cs
      | c == ')' = case stack of
          ('(':rest) -> check rest cs
          _ -> False
      | c == ']' = case stack of
          ('[':rest) -> check rest cs
          _ -> False
      | c == '}' = case stack of
          ('{':rest) -> check rest cs
          _ -> False
      | otherwise = check stack cs
