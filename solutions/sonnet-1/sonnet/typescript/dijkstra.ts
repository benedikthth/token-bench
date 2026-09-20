function main(input: string): string {
  const lines = input.split("\n").map((l) => l.trim()).filter((l) => l.length > 0);
  let idx = 0;
  const [n, m] = lines[idx++].split(/\s+/).map(Number);

  const adj: Array<Array<[number, number]>> = Array.from({ length: n }, () => []);
  for (let i = 0; i < m; i++) {
    const [u, v, w] = lines[idx++].split(/\s+/).map(Number);
    adj[u].push([v, w]);
    adj[v].push([u, w]);
  }

  const [s, t] = lines[idx++].split(/\s+/).map(Number);

  if (s === t) return "0";

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

  return dist[t] === Infinity ? "-1" : String(dist[t]);
}

const chunks: Buffer[] = [];
process.stdin.on("data", (chunk) => chunks.push(chunk));
process.stdin.on("end", () => {
  const input = Buffer.concat(chunks).toString("utf-8");
  process.stdout.write(main(input) + "\n");
});
