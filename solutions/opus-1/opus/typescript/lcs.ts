const data = await Bun.stdin.text();
const lines = data.split("\n").map((l) => l.replace(/\r$/, ""));
const a = (lines[0] ?? "").trim();
const b = (lines[1] ?? "").trim();

const n = a.length;
const m = b.length;
let prev = new Int32Array(m + 1);
let cur = new Int32Array(m + 1);
for (let i = 1; i <= n; i++) {
  const ca = a.charCodeAt(i - 1);
  for (let j = 1; j <= m; j++) {
    if (ca === b.charCodeAt(j - 1)) cur[j] = prev[j - 1] + 1;
    else cur[j] = prev[j] > cur[j - 1] ? prev[j] : cur[j - 1];
  }
  const t = prev;
  prev = cur;
  cur = t;
}
console.log(String(prev[m]));
