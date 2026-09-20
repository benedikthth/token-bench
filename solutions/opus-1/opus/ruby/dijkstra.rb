data = STDIN.read.split.map(&:to_i)
n, m = data[0], data[1]
adj = Array.new(n) { [] }
i = 2
m.times do
  u, v, w = data[i], data[i + 1], data[i + 2]
  i += 3
  adj[u] << [v, w]
  adj[v] << [u, w]
end
s, t = data[i], data[i + 1]

if s == t
  puts 0
  exit
end

dist = Array.new(n)
dist[s] = 0
heap = [[0, s]]

push = lambda do |item|
  heap << item
  k = heap.size - 1
  while k > 0
    p = (k - 1) >> 1
    break if heap[p][0] <= heap[k][0]
    heap[p], heap[k] = heap[k], heap[p]
    k = p
  end
end

pop = lambda do
  top = heap[0]
  last = heap.pop
  unless heap.empty?
    heap[0] = last
    k = 0
    size = heap.size
    loop do
      l = 2 * k + 1
      break if l >= size
      r = l + 1
      c = (r < size && heap[r][0] < heap[l][0]) ? r : l
      break if heap[k][0] <= heap[c][0]
      heap[k], heap[c] = heap[c], heap[k]
      k = c
    end
  end
  top
end

ans = -1
until heap.empty?
  d, u = pop.call
  next if d > dist[u]
  if u == t
    ans = d
    break
  end
  adj[u].each do |v, w|
    nd = d + w
    if dist[v].nil? || nd < dist[v]
      dist[v] = nd
      push.call([nd, v])
    end
  end
end

puts ans
