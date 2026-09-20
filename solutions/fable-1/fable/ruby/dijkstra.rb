# frozen_string_literal: true

# Binary min-heap over [dist, node] pairs.
class MinHeap
  def initialize
    @a = []
  end

  def empty?
    @a.empty?
  end

  def push(d, v)
    @a << [d, v]
    i = @a.size - 1
    while i > 0
      p = (i - 1) >> 1
      break if @a[p][0] <= @a[i][0]
      @a[p], @a[i] = @a[i], @a[p]
      i = p
    end
  end

  def pop
    top = @a[0]
    last = @a.pop
    unless @a.empty?
      @a[0] = last
      i = 0
      n = @a.size
      loop do
        l = 2 * i + 1
        r = l + 1
        m = i
        m = l if l < n && @a[l][0] < @a[m][0]
        m = r if r < n && @a[r][0] < @a[m][0]
        break if m == i
        @a[m], @a[i] = @a[i], @a[m]
        i = m
      end
    end
    top
  end
end

data = STDIN.read.split.map(&:to_i)
idx = 0
n = data[idx]; idx += 1
m = data[idx]; idx += 1

adj = Array.new(n) { [] }
m.times do
  u = data[idx]; v = data[idx + 1]; w = data[idx + 2]
  idx += 3
  adj[u] << [v, w]
  adj[v] << [u, w]
end

s = data[idx]; t = data[idx + 1]

if s == t
  puts 0
  exit
end

INF = Float::INFINITY
dist = Array.new(n, INF)
dist[s] = 0
heap = MinHeap.new
heap.push(0, s)
result = -1

until heap.empty?
  d, u = heap.pop
  next if d > dist[u]
  if u == t
    result = d
    break
  end
  adj[u].each do |v, w|
    nd = d + w
    if nd < dist[v]
      dist[v] = nd
      heap.push(nd, v)
    end
  end
end

puts result
