import qualified Data.Map as Map
import qualified Data.Set as Set
import Data.List (sortBy, foldl')
import Data.Ord (comparing)
import Control.Monad (replicateM)

type Graph = Map.Map Int [(Int, Int)]

main :: IO ()
main = do
  [n, m] <- fmap (map read . words) getLine
  edges <- replicateM m getLine
  [s, t] <- fmap (map read . words) getLine
  let graph = buildGraph n edges
      result = dijkstra graph n s t
  print result

buildGraph :: Int -> [String] -> Graph
buildGraph n edges = foldl' addEdge initialGraph edges
  where
    initialGraph = Map.fromList [(i, []) | i <- [0..n-1]]
    addEdge g edgeLine =
      let [u, v, w] = map read (words edgeLine)
      in Map.insertWith (++) u [(v, w)] $ Map.insertWith (++) v [(u, w)] g

dijkstra :: Graph -> Int -> Int -> Int -> Int
dijkstra graph n start target
  | start == target = 0
  | otherwise =
      let initialDist = Map.fromList [(i, if i == start then 0 else maxBound) | i <- [0..n-1]]
          finalDist = runDijkstra graph initialDist Set.empty
      in case Map.lookup target finalDist of
           Nothing -> -1
           Just d -> if d == maxBound then -1 else d

runDijkstra :: Graph -> Map.Map Int Int -> Set.Set Int -> Map.Map Int Int
runDijkstra graph distances visited =
  case findMinUnvisited distances visited of
    Nothing -> distances
    Just u ->
      let neighbors = Map.findWithDefault [] u graph
          newDistances = updateDistances distances u neighbors
          newVisited = Set.insert u visited
      in runDijkstra graph newDistances newVisited

findMinUnvisited :: Map.Map Int Int -> Set.Set Int -> Maybe Int
findMinUnvisited distances visited =
  case sortBy (comparing snd) candidates of
    [] -> Nothing
    ((n, _):_) -> Just n
  where
    candidates = [(n, d) | (n, d) <- Map.toList distances,
                           n `Set.notMember` visited, d < maxBound]

updateDistances :: Map.Map Int Int -> Int -> [(Int, Int)] -> Map.Map Int Int
updateDistances distances u neighbors =
  foldl' relax distances neighbors
  where
    dU = distances Map.! u
    relax ds (v, w) =
      let dV = distances Map.! v
          newDist = if dU == maxBound then maxBound else dU + w
      in if newDist < dV then Map.insert v newDist ds else ds
