const data = require("fs").readFileSync(0, "utf8");
const tokens = data.split(/\s+/).filter((x: string) => x.length > 0).map(Number);
let p = 0;
const n = tokens[p++];
const m = tokens[p++];

// CSR adjacency
const deg = new Int32Array(n + 1);
const eu = new Int32Array(m);
const ev = new Int32Array(m);
const ew = new Float64Array(m);
for (let i = 0; i < m; i++) {
  const u = tokens[p++];
  const v = tokens[p++];
  const w = tokens[p++];
  eu[i] = u;
  ev[i] = v;
  ew[i] = w;
  deg[u + 1]++;
  deg[v + 1]++;
}
for (let i = 0; i < n; i++) deg[i + 1] += deg[i];
const pos = deg.slice(0, n);
const adjTo = new Int32Array(2 * m);
const adjW = new Float64Array(2 * m);
for (let i = 0; i < m; i++) {
  adjTo[pos[eu[i]]] = ev[i];
  adjW[pos[eu[i]]++] = ew[i];
  adjTo[pos[ev[i]]] = eu[i];
  adjW[pos[ev[i]]++] = ew[i];
}

const s = tokens[p++];
const t = tokens[p++];

// Binary heap of (dist, node)
let heapD = new Float64Array(1024);
let heapN = new Int32Array(1024);
let hsize = 0;
function push(d: number, v: number) {
  if (hsize === heapD.length) {
    const nd = new Float64Array(hsize * 2);
    nd.set(heapD);
    heapD = nd;
    const nn = new Int32Array(hsize * 2);
    nn.set(heapN);
    heapN = nn;
  }
  let i = hsize++;
  while (i > 0) {
    const par = (i - 1) >> 1;
    if (heapD[par] <= d) break;
    heapD[i] = heapD[par];
    heapN[i] = heapN[par];
    i = par;
  }
  heapD[i] = d;
  heapN[i] = v;
}
function pop(): void {
  hsize--;
  if (hsize === 0) return;
  const d = heapD[hsize];
  const v = heapN[hsize];
  let i = 0;
  while (true) {
    let c = 2 * i + 1;
    if (c >= hsize) break;
    if (c + 1 < hsize && heapD[c + 1] < heapD[c]) c++;
    if (heapD[c] >= d) break;
    heapD[i] = heapD[c];
    heapN[i] = heapN[c];
    i = c;
  }
  heapD[i] = d;
  heapN[i] = v;
}

const dist = new Float64Array(n).fill(Infinity);
let answer = -1;
if (s === t) {
  answer = 0;
} else if (s >= 0 && s < n && t >= 0 && t < n) {
  dist[s] = 0;
  push(0, s);
  while (hsize > 0) {
    const d = heapD[0];
    const u = heapN[0];
    pop();
    if (d > dist[u]) continue;
    if (u === t) break;
    for (let k = deg[u]; k < deg[u + 1]; k++) {
      const v = adjTo[k];
      const nd = d + adjW[k];
      if (nd < dist[v]) {
        dist[v] = nd;
        push(nd, v);
      }
    }
  }
  if (dist[t] !== Infinity) answer = dist[t];
}
process.stdout.write(String(answer) + "\n");
