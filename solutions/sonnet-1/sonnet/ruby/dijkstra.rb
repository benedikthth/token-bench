require 'set'

def main
  input = $stdin.read.split("\n").reject { |l| l.strip.empty? }
  idx = 0
  n, m = input[idx].split.map(&:to_i)
  idx += 1

  adj = Array.new(n) { [] }
  m.times do
    u, v, w = input[idx].split.map(&:to_i)
    idx += 1
    adj[u] << [v, w]
    adj[v] << [u, w]
  end

  s, t = input[idx].split.map(&:to_i)

  if s == t
    puts 0
    return
  end

  dist = Array.new(n, Float::INFINITY)
  dist[s] = 0
  visited = Array.new(n, false)

  n.times do
    u = -1
    best = Float::INFINITY
    n.times do |i|
      if !visited[i] && dist[i] < best
        best = dist[i]
        u = i
      end
    end
    break if u == -1

    visited[u] = true

    adj[u].each do |v, w|
      if dist[u] + w < dist[v]
        dist[v] = dist[u] + w
      end
    end
  end

  if dist[t] == Float::INFINITY
    puts(-1)
  else
    puts dist[t].to_i
  end
end

main
