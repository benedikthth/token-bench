main :: IO ()
main = interact $ unlines . map check . lines . filter (/= '\r')

check :: String -> String
check s = if go [] s then "yes" else "no"
  where
    go stack [] = null stack
    go stack (c:cs)
      | c `elem` "([{" = go (c : stack) cs
      | otherwise = case stack of
          (o:rest) | matches o c -> go rest cs
          _ -> False
    matches '(' ')' = True
    matches '[' ']' = True
    matches '{' '}' = True
    matches _ _ = False
