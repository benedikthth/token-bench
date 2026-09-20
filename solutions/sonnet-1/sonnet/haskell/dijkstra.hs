import qualified Data.Map.Strict as M
import qualified Data.Set as S
import qualified Data.IntMap.Strict as IM
import Data.List (foldl')

main :: IO ()
main = do
  contents <- getContents
  let ws = words contents
      (n:m:rest0) = map read ws :: [Int]
      (edgeNums, rest1) = splitAt (3*m) rest0
      edges = chunk3 edgeNums
      [s, t] = rest1
      adj = buildAdj n edges
      dist = dijkstra n adj s
  case IM.lookup t dist of
    Just d -> print d
    Nothing -> print (-1 :: Int)

chunk3 :: [Int] -> [(Int, Int, Int)]
chunk3 (u:v:w:xs) = (u, v, w) : chunk3 xs
chunk3 _ = []

buildAdj :: Int -> [(Int, Int, Int)] -> IM.IntMap [(Int, Int)]
buildAdj n edges = foldl' addEdge initial edges
  where
    initial = IM.fromList [(i, []) | i <- [0 .. n - 1]]
    addEdge m (u, v, w) =
      IM.adjust ((v, w) :) u (IM.adjust ((u, w) :) v m)

dijkstra :: Int -> IM.IntMap [(Int, Int)] -> Int -> IM.IntMap Int
dijkstra _ adj s = go (S.singleton (0, s)) (IM.singleton s 0)
  where
    go pq dist =
      case S.minView pq of
        Nothing -> dist
        Just ((d, u), pq') ->
          if Just d > IM.lookup u dist
            then go pq' dist
            else
              let neighbors = IM.findWithDefault [] u adj
                  (pq'', dist'') = foldl' relax (pq', dist) neighbors
                  relax (q, ds) (v, w) =
                    let nd = d + w
                    in case IM.lookup v ds of
                         Just old | old <= nd -> (q, ds)
                         _ -> (S.insert (nd, v) q, IM.insert v nd ds)
              in go pq'' dist''
