import Data.List (group)
import Data.Char (isAsciiLower)

main :: IO ()
main = do
  s <- getContents
  let xs = filter isAsciiLower (takeWhile (/= '\n') s)
  putStrLn (concatMap (\g -> head g : show (length g)) (group xs))
