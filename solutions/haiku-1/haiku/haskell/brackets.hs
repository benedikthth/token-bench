isBalanced :: String -> Bool
isBalanced s =
  case foldl process (Just []) s of
    Just [] -> True
    _ -> False
  where
    process (Just stack) c
      | c `elem` "([{" = Just (c : stack)
      | c == ')' = case stack of
          ('(':rest) -> Just rest
          _ -> Nothing
      | c == ']' = case stack of
          ('[':rest) -> Just rest
          _ -> Nothing
      | c == '}' = case stack of
          ('{':rest) -> Just rest
          _ -> Nothing
      | otherwise = Nothing
    process Nothing _ = Nothing

main :: IO ()
main = interact $ unlines . map ((\b -> if b then "yes" else "no") . isBalanced) . lines
