const data = await Bun.stdin.text();
const tokens = data.split(/\s+/).filter((t) => t.length > 0);
let p = 0;
const R = parseInt(tokens[p++]);
const C = parseInt(tokens[p++]);
const m: string[][] = [];
for (let i = 0; i < R; i++) {
  const row: string[] = [];
  for (let j = 0; j < C; j++) row.push(String(parseInt(tokens[p++])));
  m.push(row);
}
const out: string[] = [];
for (let j = 0; j < C; j++) {
  const line: string[] = [];
  for (let i = 0; i < R; i++) line.push(m[i][j]);
  out.push(line.join(" "));
}
process.stdout.write(out.length ? out.join("\n") + "\n" : "");
