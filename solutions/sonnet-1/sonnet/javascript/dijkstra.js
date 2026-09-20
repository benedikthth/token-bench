const lines = require('fs').readFileSync('/dev/stdin', 'utf8').split('\n');

let idx = 0;
const [n, m] = lines[idx++].trim().split(/\s+/).map(Number);

const adj = Array.from({ length: n }, () => []);
for (let i = 0; i < m; i++) {
  const [u, v, w] = lines[idx++].trim().split(/\s+/).map(Number);
  adj[u].push([v, w]);
  adj[v].push([u, w]);
}

const [s, t] = lines[idx++].trim().split(/\s+/).map(Number);

if (s === t) {
  console.log(0);
} else {
  const dist = new Array(n).fill(Infinity);
  dist[s] = 0;
  const visited = new Array(n).fill(false);

  for (let iter = 0; iter < n; iter++) {
    let u = -1;
    let best = Infinity;
    for (let i = 0; i < n; i++) {
      if (!visited[i] && dist[i] < best) {
        best = dist[i];
        u = i;
      }
    }
    if (u === -1) break;
    visited[u] = true;
    for (const [v, w] of adj[u]) {
      if (dist[u] + w < dist[v]) {
        dist[v] = dist[u] + w;
      }
    }
  }

  console.log(dist[t] === Infinity ? -1 : dist[t]);
}
