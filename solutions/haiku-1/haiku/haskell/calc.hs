import Data.Char (isDigit, isSpace)

-- Parser type
type Parser a = String -> Maybe (a, String)

-- Parse a number
parseNumber :: Parser Int
parseNumber s = case dropWhile isSpace s of
    [] -> Nothing
    s' -> case span isDigit s' of
        ("", _) -> Nothing
        (digits, rest) -> Just (read digits, rest)

-- Parse a factor (number or parenthesized expression)
parseFactor :: Parser Int
parseFactor s = case dropWhile isSpace s of
    ('(' : rest) -> case parseExpr rest of
        Just (val, rest') -> case dropWhile isSpace rest' of
            (')' : rest'') -> Just (val, rest'')
            _ -> Nothing
        Nothing -> Nothing
    s' -> parseNumber s'

-- Parse a term (factors with * and /)
parseTerm :: Parser Int
parseTerm s = case parseFactor s of
    Just (val, rest) -> parseTermRest val rest
    Nothing -> Nothing

parseTermRest :: Int -> String -> Maybe (Int, String)
parseTermRest val s = case dropWhile isSpace s of
    ('*' : rest) -> case parseFactor rest of
        Just (val', rest') -> parseTermRest (val * val') rest'
        Nothing -> Nothing
    ('/' : rest) -> case parseFactor rest of
        Just (val', rest') -> parseTermRest (val `quot` val') rest'
        Nothing -> Nothing
    _ -> Just (val, s)

-- Parse an expression (terms with + and -)
parseExpr :: Parser Int
parseExpr s = case parseTerm s of
    Just (val, rest) -> parseExprRest val rest
    Nothing -> Nothing

parseExprRest :: Int -> String -> Maybe (Int, String)
parseExprRest val s = case dropWhile isSpace s of
    ('+' : rest) -> case parseTerm rest of
        Just (val', rest') -> parseExprRest (val + val') rest'
        Nothing -> Nothing
    ('-' : rest) -> case parseTerm rest of
        Just (val', rest') -> parseExprRest (val - val') rest'
        Nothing -> Nothing
    _ -> Just (val, s)

-- Evaluate an expression string
evaluate :: String -> Maybe Int
evaluate s = case parseExpr s of
    Just (val, _) -> Just val
    Nothing -> Nothing

main :: IO ()
main = do
    input <- getContents
    mapM_ processLine (lines input)

processLine :: String -> IO ()
processLine s = case evaluate s of
    Just val -> print val
    Nothing -> return ()
