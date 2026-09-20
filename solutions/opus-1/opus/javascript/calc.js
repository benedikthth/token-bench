const data = require('fs').readFileSync(0, 'utf8');
const out = [];

function evaluate(s) {
  const tokens = s.match(/\d+|[-+*/()]/g) || [];
  let pos = 0;

  function primary() {
    const t = tokens[pos++];
    if (t === '(') {
      const v = expr();
      pos++; // ')'
      return v;
    }
    return BigInt(t);
  }

  function term() {
    let v = primary();
    while (tokens[pos] === '*' || tokens[pos] === '/') {
      const op = tokens[pos++];
      const r = primary();
      v = op === '*' ? v * r : v / r;
    }
    return v;
  }

  function expr() {
    let v = term();
    while (tokens[pos] === '+' || tokens[pos] === '-') {
      const op = tokens[pos++];
      const r = term();
      v = op === '+' ? v + r : v - r;
    }
    return v;
  }

  return expr();
}

for (const line of data.split('\n')) {
  if (line.trim() === '') continue;
  out.push(evaluate(line).toString());
}
if (out.length) process.stdout.write(out.join('\n') + '\n');
