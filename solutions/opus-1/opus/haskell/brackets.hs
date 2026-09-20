main :: IO ()
main = interact $ unlines . map (answer . filter (/= '\r')) . lines

answer :: String -> String
answer s = if go [] s then "yes" else "no"

go :: String -> String -> Bool
go st [] = null st
go st (c:cs)
  | c `elem` "([{" = go (c:st) cs
  | otherwise = case st of
      (o:rest) | match o c -> go rest cs
      _ -> False

match :: Char -> Char -> Bool
match '(' ')' = True
match '[' ']' = True
match '{' '}' = True
match _ _ = False
