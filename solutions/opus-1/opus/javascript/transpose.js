const t = require('fs').readFileSync(0, 'utf8').split(/\s+/).filter(Boolean);
const R = +t[0], C = +t[1];
const out = [];
for (let j = 0; j < C; j++) {
  const row = [];
  for (let i = 0; i < R; i++) row.push(t[2 + i * C + j]);
  out.push(row.join(' '));
}
process.stdout.write(out.length ? out.join('\n') + '\n' : '');
