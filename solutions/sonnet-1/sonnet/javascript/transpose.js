const lines = require('fs').readFileSync(0, 'utf8').split('\n');

let idx = 0;
const [R, C] = lines[idx++].trim().split(/\s+/).map(Number);

const matrix = [];
for (let i = 0; i < R; i++) {
  matrix.push(lines[idx++].trim().split(/\s+/).map(Number));
}

const out = [];
for (let c = 0; c < C; c++) {
  const row = [];
  for (let r = 0; r < R; r++) {
    row.push(matrix[r][c]);
  }
  out.push(row.join(' '));
}

process.stdout.write(out.join('\n') + '\n');
