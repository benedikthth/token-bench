const text = await Bun.stdin.text();
const counts = new Map<string, number>();
for (const m of text.matchAll(/[A-Za-z]+/g)) {
  const w = m[0].toLowerCase();
  counts.set(w, (counts.get(w) ?? 0) + 1);
}
const entries = [...counts.entries()].sort((a, b) =>
  b[1] !== a[1] ? b[1] - a[1] : a[0] < b[0] ? -1 : a[0] > b[0] ? 1 : 0
);
let out = "";
for (const [w, c] of entries) out += `${w} ${c}\n`;
process.stdout.write(out);
