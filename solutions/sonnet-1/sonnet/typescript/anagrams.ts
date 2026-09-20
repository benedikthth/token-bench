const lines = require("fs").readFileSync(0, "utf8").split("\n");
const words: string[] = [];
for (const line of lines) {
  const w = line.trim();
  if (w.length > 0) words.push(w);
}

const groups = new Map<string, string[]>();
for (const w of words) {
  const key = w.split("").sort().join("");
  const g = groups.get(key);
  if (g) g.push(w);
  else groups.set(key, [w]);
}

const result: string[][] = [];
for (const g of groups.values()) {
  g.sort();
  result.push(g);
}

result.sort((a, b) => (a[0] < b[0] ? -1 : a[0] > b[0] ? 1 : 0));

const out = result.map((g) => g.join(" ")).join("\n");
process.stdout.write(out + (out.length > 0 ? "\n" : ""));
