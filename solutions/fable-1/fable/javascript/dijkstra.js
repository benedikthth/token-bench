const data = require('fs').readFileSync(0, 'utf8');
let pos = 0;
function nextInt() {
  while (pos < data.length) {
    const c = data.charCodeAt(pos);
    if ((c >= 48 && c <= 57) || c === 45) break;
    pos++;
  }
  if (pos >= data.length) return NaN;
  let neg = false;
  if (data.charCodeAt(pos) === 45) { neg = true; pos++; }
  let n = 0;
  while (pos < data.length) {
    const c = data.charCodeAt(pos);
    if (c < 48 || c > 57) break;
    n = n * 10 + (c - 48);
    pos++;
  }
  return neg ? -n : n;
}

const N = nextInt();
const M = nextInt();
if (Number.isNaN(N)) {
  process.exit(0);
}
const head = new Int32Array(N).fill(-1);
const nxt = new Int32Array(2 * M);
const to = new Int32Array(2 * M);
const wt = new Float64Array(2 * M);
let ec = 0;
function addEdge(u, v, w) {
  to[ec] = v; wt[ec] = w; nxt[ec] = head[u]; head[u] = ec++;
}
for (let i = 0; i < M; i++) {
  const u = nextInt(), v = nextInt(), w = nextInt();
  if (u < 0 || u >= N || v < 0 || v >= N) continue;
  addEdge(u, v, w);
  addEdge(v, u, w);
}
const s = nextInt();
const t = nextInt();

function solve() {
  if (s === t) return 0;
  if (s < 0 || s >= N || t < 0 || t >= N) return -1;
  const dist = new Float64Array(N).fill(Infinity);
  dist[s] = 0;
  // binary heap of (dist, node)
  let hd = [0];
  let hn = [s];
  function push(d, v) {
    let i = hd.length;
    hd.push(d); hn.push(v);
    while (i > 0) {
      const p = (i - 1) >> 1;
      if (hd[p] <= d) break;
      hd[i] = hd[p]; hn[i] = hn[p];
      i = p;
    }
    hd[i] = d; hn[i] = v;
  }
  function pop() {
    const d = hd[0], v = hn[0];
    const ld = hd.pop(), lv = hn.pop();
    const n = hd.length;
    if (n > 0) {
      let i = 0;
      while (true) {
        let l = 2 * i + 1;
        if (l >= n) break;
        let r = l + 1;
        let c = (r < n && hd[r] < hd[l]) ? r : l;
        if (hd[c] >= ld) break;
        hd[i] = hd[c]; hn[i] = hn[c];
        i = c;
      }
      hd[i] = ld; hn[i] = lv;
    }
    return [d, v];
  }
  while (hd.length > 0) {
    const [d, u] = pop();
    if (d > dist[u]) continue;
    if (u === t) return d;
    for (let e = head[u]; e !== -1; e = nxt[e]) {
      const v = to[e];
      const nd = d + wt[e];
      if (nd < dist[v]) {
        dist[v] = nd;
        push(nd, v);
      }
    }
  }
  return -1;
}

const ans = solve();
process.stdout.write(String(ans) + '\n');
