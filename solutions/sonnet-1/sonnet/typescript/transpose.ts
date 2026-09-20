const input = await Bun.stdin.text();
const tokens = input.split(/\s+/).filter((s) => s.length > 0).map(Number);

let idx = 0;
const R = tokens[idx++];
const C = tokens[idx++];

const matrix: number[][] = [];
for (let r = 0; r < R; r++) {
  const row: number[] = [];
  for (let c = 0; c < C; c++) {
    row.push(tokens[idx++]);
  }
  matrix.push(row);
}

const lines: string[] = [];
for (let c = 0; c < C; c++) {
  const row: number[] = [];
  for (let r = 0; r < R; r++) {
    row.push(matrix[r][c]);
  }
  lines.push(row.join(" "));
}

console.log(lines.join("\n"));
