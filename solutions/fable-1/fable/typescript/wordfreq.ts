const input = await Bun.stdin.text();
const counts = new Map<string, number>();
const re = /[A-Za-z]+/g;
let m: RegExpExecArray | null;
while ((m = re.exec(input)) !== null) {
  const w = m[0].toLowerCase();
  counts.set(w, (counts.get(w) ?? 0) + 1);
}
const entries = [...counts.entries()];
entries.sort((a, b) => b[1] - a[1] || (a[0] < b[0] ? -1 : a[0] > b[0] ? 1 : 0));
const out: string[] = [];
for (const [w, c] of entries) out.push(`${w} ${c}`);
process.stdout.write(out.length ? out.join("\n") + "\n" : "");
