const data = require('fs').readFileSync(0, 'utf8');
const tokens = data.split(/\s+/).filter(Boolean);
const R = parseInt(tokens[0], 10);
const C = parseInt(tokens[1], 10);
const out = [];
for (let j = 0; j < C; j++) {
  const row = new Array(R);
  for (let i = 0; i < R; i++) {
    row[i] = tokens[2 + i * C + j];
  }
  out.push(row.join(' '));
}
process.stdout.write(out.join('\n') + (out.length ? '\n' : ''));
