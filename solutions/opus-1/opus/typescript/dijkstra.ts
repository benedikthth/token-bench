import { readFileSync } from "fs";

const data = readFileSync(0);
let pos = 0;
function next(): number {
  while (pos < data.length && (data[pos] < 48 || data[pos] > 57) && data[pos] !== 45) pos++;
  let neg = false;
  if (data[pos] === 45) { neg = true; pos++; }
  let x = 0;
  while (pos < data.length && data[pos] >= 48 && data[pos] <= 57) {
    x = x * 10 + (data[pos] - 48);
    pos++;
  }
  return neg ? -x : x;
}

const n = next();
const m = next();
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
const s = next();
const t = next();

if (s === t) {
  console.log("0");
} else {
  const dist = new Float64Array(n).fill(Infinity);
  const hk: number[] = [];
  const hv: number[] = [];
  const push = (k: number, v: number) => {
    let i = hk.length;
    hk.push(k); hv.push(v);
    while (i > 0) {
      const p = (i - 1) >> 1;
      if (hk[p] <= k) break;
      hk[i] = hk[p]; hv[i] = hv[p];
      i = p;
    }
    hk[i] = k; hv[i] = v;
  };
  const pop = () => {
    const lk = hk.pop()!, lv = hv.pop()!;
    const len = hk.length;
    if (len === 0) return;
    let i = 0;
    while (true) {
      let c = 2 * i + 1;
      if (c >= len) break;
      if (c + 1 < len && hk[c + 1] < hk[c]) c++;
      if (hk[c] >= lk) break;
      hk[i] = hk[c]; hv[i] = hv[c];
      i = c;
    }
    hk[i] = lk; hv[i] = lv;
  };
  dist[s] = 0;
  push(0, s);
  let ans = -1;
  while (hk.length > 0) {
    const d = hk[0], u = hv[0];
    pop();
    if (d > dist[u]) continue;
    if (u === t) { ans = d; break; }
    for (let e = head[u]; e !== -1; e = nxt[e]) {
      const v = to[e];
      const nd = d + wt[e];
      if (nd < dist[v]) {
        dist[v] = nd;
        push(nd, v);
      }
    }
  }
  console.log(String(ans));
}
