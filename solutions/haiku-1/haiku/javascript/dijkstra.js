const readline = require('readline');

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
  terminal: false
});

const lines = [];

rl.on('line', (line) => {
  lines.push(line);
});

rl.on('close', () => {
  // Parse first line: N M
  const [N, M] = lines[0].split(' ').map(Number);

  // Initialize graph as adjacency list
  const graph = Array.from({ length: N }, () => []);

  // Parse edges
  for (let i = 1; i <= M; i++) {
    const [u, v, w] = lines[i].split(' ').map(Number);
    graph[u].push({ node: v, weight: w });
    graph[v].push({ node: u, weight: w });
  }

  // Parse start and target
  const [s, t] = lines[M + 1].split(' ').map(Number);

  // Special case: start equals target
  if (s === t) {
    console.log(0);
    process.exit(0);
  }

  // Dijkstra's algorithm
  const distances = new Array(N).fill(Infinity);
  const visited = new Array(N).fill(false);
  distances[s] = 0;

  for (let i = 0; i < N; i++) {
    // Find unvisited node with minimum distance
    let minDist = Infinity;
    let minNode = -1;

    for (let j = 0; j < N; j++) {
      if (!visited[j] && distances[j] < minDist) {
        minDist = distances[j];
        minNode = j;
      }
    }

    if (minNode === -1) break; // No more reachable nodes

    visited[minNode] = true;

    // Update distances of neighbors
    for (const { node, weight } of graph[minNode]) {
      if (!visited[node]) {
        distances[node] = Math.min(
          distances[node],
          distances[minNode] + weight
        );
      }
    }
  }

  // Output result
  if (distances[t] === Infinity) {
    console.log(-1);
  } else {
    console.log(distances[t]);
  }
});
