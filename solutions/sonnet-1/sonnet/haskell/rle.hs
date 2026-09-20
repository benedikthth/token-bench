import Data.List (group)

encode :: String -> String
encode s = concatMap (\g -> [head g] ++ show (length g)) (group s)

main :: IO ()
main = do
  contents <- getContents
  let line = takeWhile (/= '\n') contents
  putStrLn (encode line)
