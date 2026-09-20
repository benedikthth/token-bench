const input = require("fs").readFileSync(0, "utf8");
const tokens = input.split(/\s+/).filter((t: string) => t.length > 0);
let idx = 0;
const R = parseInt(tokens[idx++], 10);
const C = parseInt(tokens[idx++], 10);
const rows: string[][] = [];
for (let i = 0; i < R; i++) {
  const row: string[] = [];
  for (let j = 0; j < C; j++) {
    row.push(tokens[idx++]);
  }
  rows.push(row);
}
const out: string[] = [];
for (let j = 0; j < C; j++) {
  const parts: string[] = [];
  for (let i = 0; i < R; i++) {
    parts.push(rows[i][j]);
  }
  out.push(parts.join(" "));
}
process.stdout.write(out.join("\n") + (out.length ? "\n" : ""));
