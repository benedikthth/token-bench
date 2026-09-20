import * as readline from "readline";

interface Edge {
  to: number;
  weight: number;
}

async function main() {
  const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout,
    terminal: false,
  });

  const lines: string[] = [];
  for await (const line of rl) {
    lines.push(line.trim());
  }

  // Parse input
  const [n, m] = lines[0].split(" ").map(Number);

  // Build adjacency list
  const graph: Edge[][] = Array.from({ length: n }, () => []);

  for (let i = 1; i <= m; i++) {
    const [u, v, w] = lines[i].split(" ").map(Number);
    graph[u].push({ to: v, weight: w });
    graph[v].push({ to: u, weight: w });
  }

  const [s, t] = lines[m + 1].split(" ").map(Number);

  // Special case: start equals target
  if (s === t) {
    console.log(0);
    return;
  }

  // Dijkstra's algorithm
  const dist = Array(n).fill(Infinity);
  dist[s] = 0;

  const visited = Array(n).fill(false);
  const pq: [number, number][] = [[0, s]]; // [distance, node]

  while (pq.length > 0) {
    // Find the unvisited node with minimum distance
    let minIdx = 0;
    for (let i = 1; i < pq.length; i++) {
      if (pq[i][0] < pq[minIdx][0]) {
        minIdx = i;
      }
    }

    const [d, u] = pq[minIdx];
    pq.splice(minIdx, 1);

    if (visited[u]) continue;
    visited[u] = true;

    if (d > dist[u]) continue;

    // Early termination if we reached the target
    if (u === t) {
      console.log(dist[t]);
      return;
    }

    for (const edge of graph[u]) {
      const v = edge.to;
      const w = edge.weight;

      if (dist[u] + w < dist[v]) {
        dist[v] = dist[u] + w;
        pq.push([dist[v], v]);
      }
    }
  }

  // Check if target is reachable
  if (dist[t] === Infinity) {
    console.log(-1);
  } else {
    console.log(dist[t]);
  }
}

main().catch(console.error);
