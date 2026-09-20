const input = await Bun.stdin.text();

const table: [number, string][] = [
  [1000, "M"],
  [900, "CM"],
  [500, "D"],
  [400, "CD"],
  [100, "C"],
  [90, "XC"],
  [50, "L"],
  [40, "XL"],
  [10, "X"],
  [9, "IX"],
  [5, "V"],
  [4, "IV"],
  [1, "I"],
];

function toRoman(n: number): string {
  let out = "";
  for (const [value, sym] of table) {
    while (n >= value) {
      out += sym;
      n -= value;
    }
  }
  return out;
}

const lines = input.split(/\r?\n/);
const results: string[] = [];
for (const line of lines) {
  const s = line.trim();
  if (s === "") continue;
  const n = parseInt(s, 10);
  if (Number.isNaN(n)) continue;
  results.push(toRoman(n));
}

process.stdout.write(results.join("\n") + (results.length ? "\n" : ""));
