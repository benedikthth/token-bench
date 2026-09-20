main :: IO ()
main = do
  contents <- getContents
  let ls = lines contents
      (rc:rest) = ls
      [r, c] = map read (words rc)
      rows = map (map read . words) (take r rest) :: [[Integer]]
      cols = if r == 0 then replicate c [] else transposeMat rows
  mapM_ (putStrLn . unwords . map show) cols

transposeMat :: [[a]] -> [[a]]
transposeMat [] = []
transposeMat ([]:_) = []
transposeMat xss = map head xss : transposeMat (map tail xss)
