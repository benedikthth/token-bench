import Data.List (group)

rle :: String -> String
rle = concatMap (\g -> head g : show (length g)) . group

main :: IO ()
main = do
  input <- getContents
  let s = filter (`elem` ['a' .. 'z']) input
  putStrLn (rle s)
