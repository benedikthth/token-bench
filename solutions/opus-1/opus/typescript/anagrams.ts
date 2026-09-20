const input = await Bun.stdin.text();
const words = input.split(/\r?\n/).map((w) => w.trim()).filter((w) => w.length > 0);

const groups = new Map<string, string[]>();
for (const w of words) {
  const key = w.split("").sort().join("");
  const g = groups.get(key);
  if (g) g.push(w);
  else groups.set(key, [w]);
}

const cmp = (a: string, b: string) => (a < b ? -1 : a > b ? 1 : 0);
const result = [...groups.values()].map((g) => g.sort(cmp));
result.sort((a, b) => cmp(a[0], b[0]));

const out = result.map((g) => g.join(" ")).join("\n");
process.stdout.write(out.length > 0 ? out + "\n" : "");
