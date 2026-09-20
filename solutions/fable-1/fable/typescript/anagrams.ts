const input = await Bun.stdin.text();
const words = input.split(/\r?\n/).filter((w) => w.length > 0);

const groups = new Map<string, string[]>();
for (const w of words) {
  const key = w.split("").sort().join("");
  const g = groups.get(key);
  if (g) g.push(w);
  else groups.set(key, [w]);
}

const result: string[][] = [];
for (const g of groups.values()) {
  g.sort((a, b) => (a < b ? -1 : a > b ? 1 : 0));
  result.push(g);
}
result.sort((a, b) => (a[0] < b[0] ? -1 : a[0] > b[0] ? 1 : 0));

const out = result.map((g) => g.join(" ")).join("\n");
process.stdout.write(out.length > 0 ? out + "\n" : "");
