const input = await Bun.stdin.text();
const vals: [number, string][] = [
  [1000, "M"], [900, "CM"], [500, "D"], [400, "CD"],
  [100, "C"], [90, "XC"], [50, "L"], [40, "XL"],
  [10, "X"], [9, "IX"], [5, "V"], [4, "IV"], [1, "I"],
];
const out: string[] = [];
for (const line of input.split("\n")) {
  const t = line.trim();
  if (!t) continue;
  let n = parseInt(t, 10);
  let s = "";
  for (const [v, r] of vals) {
    while (n >= v) { s += r; n -= v; }
  }
  out.push(s);
}
process.stdout.write(out.length ? out.join("\n") + "\n" : "");
