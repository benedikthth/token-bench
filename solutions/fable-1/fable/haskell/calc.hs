module Main where

import Data.Char (isDigit, isSpace)

-- Grammar:
--   expr   := term (('+' | '-') term)*
--   term   := factor (('*' | '/') factor)*
--   factor := number | '(' expr ')'

type Parser a = String -> (a, String)

skipSpaces :: String -> String
skipSpaces = dropWhile isSpace

expr :: Parser Integer
expr s = let (t, rest) = term s in loop t (skipSpaces rest)
  where
    loop acc ('+':r) = let (t, r') = term r in loop (acc + t) (skipSpaces r')
    loop acc ('-':r) = let (t, r') = term r in loop (acc - t) (skipSpaces r')
    loop acc r       = (acc, r)

term :: Parser Integer
term s = let (f, rest) = factor s in loop f (skipSpaces rest)
  where
    loop acc ('*':r) = let (f, r') = factor r in loop (acc * f) (skipSpaces r')
    loop acc ('/':r) = let (f, r') = factor r in loop (acc `quot` f) (skipSpaces r')
    loop acc r       = (acc, r)

factor :: Parser Integer
factor s = case skipSpaces s of
  ('(':r) -> let (v, r') = expr r
             in case skipSpaces r' of
                  (')':r'') -> (v, r'')
                  other     -> (v, other)
  r -> let (ds, r') = span isDigit r
       in if null ds then (0, r') else (read ds, r')

evalLine :: String -> Integer
evalLine = fst . expr

main :: IO ()
main = do
  contents <- getContents
  let ls = filter (not . all isSpace) (lines contents)
  mapM_ (print . evalLine) ls
