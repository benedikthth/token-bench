const data = require('fs').readFileSync(0, 'utf8');
let pos = 0;
function next() {
  while (pos < data.length) {
    const c = data.charCodeAt(pos);
    if (c >= 48 && c <= 57) break;
    pos++;
  }
  let x = 0;
  while (pos < data.length) {
    const c = data.charCodeAt(pos);
    if (c < 48 || c > 57) break;
    x = x * 10 + (c - 48);
    pos++;
  }
  return x;
}

const n = next(), m = next();
const head = new Int32Array(n).fill(-1);
const nxt = new Int32Array(2 * m);
const to = new Int32Array(2 * m);
const wt = new Float64Array(2 * m);
let ec = 0;
for (let i = 0; i < m; i++) {
  const u = next(), v = next(), w = next();
  to[ec] = v; wt[ec] = w; nxt[ec] = head[u]; head[u] = ec++;
  to[ec] = u; wt[ec] = w; nxt[ec] = head[v]; head[v] = ec++;
}
const s = next(), t = next();

if (s === t) {
  console.log('0');
} else {
  const dist = new Float64Array(n).fill(Infinity);
  const hd = [], hn = [];
  const push = (d, v) => {
    let i = hd.length;
    hd.push(d); hn.push(v);
    while (i > 0) {
      const p = (i - 1) >> 1;
      if (hd[p] <= d) break;
      hd[i] = hd[p]; hn[i] = hn[p];
      i = p;
    }
    hd[i] = d; hn[i] = v;
  };
  const pop = () => {
    const ld = hd.pop(), ln = hn.pop();
    const size = hd.length;
    if (size === 0) return;
    let i = 0;
    while (true) {
      let c = 2 * i + 1;
      if (c >= size) break;
      if (c + 1 < size && hd[c + 1] < hd[c]) c++;
      if (hd[c] >= ld) break;
      hd[i] = hd[c]; hn[i] = hn[c];
      i = c;
    }
    hd[i] = ld; hn[i] = ln;
  };
  dist[s] = 0;
  push(0, s);
  let ans = -1;
  while (hd.length > 0) {
    const d = hd[0], u = hn[0];
    pop();
    if (d > dist[u]) continue;
    if (u === t) { ans = d; break; }
    for (let e = head[u]; e !== -1; e = nxt[e]) {
      const v = to[e], nd = d + wt[e];
      if (nd < dist[v]) { dist[v] = nd; push(nd, v); }
    }
  }
  console.log(String(ans));
}
