import Data.Char (isDigit, isSpace)

data Tok = TNum Integer | TOp Char deriving Show

tokenize :: String -> [Tok]
tokenize [] = []
tokenize s@(c:cs)
  | isSpace c = tokenize cs
  | isDigit c = let (d, rest) = span isDigit s in TNum (read d) : tokenize rest
  | otherwise = TOp c : tokenize cs

expr :: [Tok] -> (Integer, [Tok])
expr ts = let (v, r) = term ts in go v r
  where
    go acc (TOp '+' : r) = let (v, r') = term r in go (acc + v) r'
    go acc (TOp '-' : r) = let (v, r') = term r in go (acc - v) r'
    go acc r = (acc, r)

term :: [Tok] -> (Integer, [Tok])
term ts = let (v, r) = factor ts in go v r
  where
    go acc (TOp '*' : r) = let (v, r') = factor r in go (acc * v) r'
    go acc (TOp '/' : r) = let (v, r') = factor r in go (acc `quot` v) r'
    go acc r = (acc, r)

factor :: [Tok] -> (Integer, [Tok])
factor (TNum n : r) = (n, r)
factor (TOp '(' : r) = case expr r of
  (v, TOp ')' : r') -> (v, r')
  (v, r') -> (v, r')
factor r = (0, r)

main :: IO ()
main = do
  input <- getContents
  let ls = filter (not . all isSpace) (lines input)
  mapM_ (print . fst . expr . tokenize) ls
