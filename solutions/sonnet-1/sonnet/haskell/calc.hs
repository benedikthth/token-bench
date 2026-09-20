import Data.Char (isDigit, isSpace)

skipSpace :: String -> String
skipSpace = dropWhile isSpace

parseExpr :: String -> (Integer, String)
parseExpr s = go (parseTerm s)
  where
    go (v, r) = case skipSpace r of
      ('+':rest) -> let (v2, r2) = parseTerm rest in go (v + v2, r2)
      ('-':rest) -> let (v2, r2) = parseTerm rest in go (v - v2, r2)
      _          -> (v, r)

parseTerm :: String -> (Integer, String)
parseTerm s = go (parseFactor s)
  where
    go (v, r) = case skipSpace r of
      ('*':rest) -> let (v2, r2) = parseFactor rest in go (v * v2, r2)
      ('/':rest) -> let (v2, r2) = parseFactor rest in go (v `quot` v2, r2)
      _          -> (v, r)

parseFactor :: String -> (Integer, String)
parseFactor s = case skipSpace s of
  ('(':rest) ->
    let (v, r)  = parseExpr rest
        r'      = skipSpace r
    in case r' of
         (')':r2) -> (v, r2)
         _        -> error "expected ')'"
  s' ->
    let (numStr, rest) = span isDigit s'
    in if null numStr
         then error ("expected number at: " ++ s')
         else (read numStr, rest)

evalLine :: String -> Integer
evalLine = fst . parseExpr

main :: IO ()
main = do
  contents <- getContents
  let ls = lines contents
  mapM_ (\l -> if all isSpace l then return () else print (evalLine l)) ls
