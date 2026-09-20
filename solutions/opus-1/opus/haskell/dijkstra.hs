import qualified Data.ByteString.Char8 as B
import qualified Data.Set as S
import qualified Data.IntMap.Strict as IM
import Data.Array
import Data.Char (isSpace)

readInts :: B.ByteString -> [Int]
readInts s = case B.readInt (B.dropWhile isSpace s) of
  Just (x, r) -> x : readInts r
  Nothing -> []

main :: IO ()
main = do
  xs <- readInts <$> B.getContents
  let (n:m:rest) = xs
      (es, rest') = splitAt (3 * m) rest
      (s:t:_) = rest'
      triples (u:v:w:r) = (u, (v, w)) : (v, (u, w)) : triples r
      triples _ = []
      adj = accumArray (flip (:)) [] (0, max 0 (n - 1)) (triples es) :: Array Int [(Int, Int)]
      go dist pq = case S.minView pq of
        Nothing -> -1
        Just ((d, u), pq')
          | u == t -> d
          | d > IM.findWithDefault maxBound u dist -> go dist pq'
          | otherwise ->
              let step (dm, q) (v, w) =
                    let nd = d + w
                    in if nd < IM.findWithDefault maxBound v dm
                         then (IM.insert v nd dm, S.insert (nd, v) q)
                         else (dm, q)
                  (dist', pq'') = foldl step (dist, pq') (adj ! u)
              in go dist' pq''
  print $ if s == t then 0 else go (IM.singleton s 0) (S.singleton (0, s))
