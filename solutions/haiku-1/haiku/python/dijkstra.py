import heapq
from collections import defaultdict

def solve():
    # Read N, M
    n, m = map(int, input().split())

    # Build the graph
    graph = defaultdict(list)

    # Read edges
    for _ in range(m):
        u, v, w = map(int, input().split())
        graph[u].append((v, w))
        graph[v].append((u, w))  # undirected

    # Read s, t
    s, t = map(int, input().split())

    # If start equals target
    if s == t:
        return 0

    # Dijkstra's algorithm
    dist = [float('inf')] * n
    dist[s] = 0
    pq = [(0, s)]  # (distance, node)

    while pq:
        d, u = heapq.heappop(pq)

        if d > dist[u]:
            continue

        if u == t:
            return d

        for v, w in graph[u]:
            if dist[u] + w < dist[v]:
                dist[v] = dist[u] + w
                heapq.heappush(pq, (dist[v], v))

    # If we reach here, there's no path
    return -1

print(solve())
