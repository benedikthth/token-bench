const data = require('fs').readFileSync(0, 'utf8');
const vals = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1];
const syms = ['M', 'CM', 'D', 'CD', 'C', 'XC', 'L', 'XL', 'X', 'IX', 'V', 'IV', 'I'];
const out = [];
for (const tok of data.split(/\s+/)) {
  if (!tok) continue;
  let n = parseInt(tok, 10);
  let s = '';
  for (let i = 0; i < vals.length; i++) {
    while (n >= vals[i]) { s += syms[i]; n -= vals[i]; }
  }
  out.push(s);
}
process.stdout.write(out.length ? out.join('\n') + '\n' : '');
