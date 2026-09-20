import Data.List (group)

main :: IO ()
main = do
  line <- getLine
  putStr $ runLengthEncode line

runLengthEncode :: String -> String
runLengthEncode = concat . map encodeRun . group
  where
    encodeRun run = [head run] ++ show (length run)
