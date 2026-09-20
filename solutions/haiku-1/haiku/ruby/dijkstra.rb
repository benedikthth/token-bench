# Read N and M
n, m = gets.strip.split.map(&:to_i)

# Build adjacency list
graph = Array.new(n) { [] }
m.times do
  u, v, w = gets.strip.split.map(&:to_i)
  graph[u] << [v, w]
  graph[v] << [u, w]  # undirected
end

# Read start and target
s, t = gets.strip.split.map(&:to_i)

# Special case: start equals target
if s == t
  puts 0
else
  # Dijkstra's algorithm
  dist = Array.new(n, Float::INFINITY)
  visited = Array.new(n, false)
  dist[s] = 0

  n.times do
    # Find unvisited node with minimum distance
    u = -1
    min_dist = Float::INFINITY
    n.times do |i|
      if !visited[i] && dist[i] < min_dist
        u = i
        min_dist = dist[i]
      end
    end

    # Break if no unvisited node with finite distance
    break if u == -1 || dist[u] == Float::INFINITY

    visited[u] = true

    # Early termination if we reach the target
    break if u == t

    # Relax edges
    graph[u].each do |v, w|
      if dist[u] + w < dist[v]
        dist[v] = dist[u] + w
      end
    end
  end

  # Output result
  if dist[t] == Float::INFINITY
    puts -1
  else
    puts dist[t]
  end
end
