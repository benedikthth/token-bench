const readline = require('readline');

function evaluate(expr) {
  let pos = 0;

  function peek() {
    while (pos < expr.length && expr[pos] === ' ') pos++;
    return expr[pos];
  }

  function parseNumber() {
    while (expr[pos] === ' ') pos++;
    let start = pos;
    while (pos < expr.length && expr[pos] >= '0' && expr[pos] <= '9') pos++;
    return parseInt(expr.slice(start, pos), 10);
  }

  function parseFactor() {
    const c = peek();
    if (c === '(') {
      pos++;
      const v = parseExpr();
      while (expr[pos] === ' ') pos++;
      pos++; // consume ')'
      return v;
    }
    return parseNumber();
  }

  function parseTerm() {
    let v = parseFactor();
    while (true) {
      const c = peek();
      if (c === '*' || c === '/') {
        pos++;
        const rhs = parseFactor();
        if (c === '*') v = v * rhs;
        else {
          const q = v / rhs;
          v = q < 0 ? Math.ceil(q) : Math.floor(q);
        }
      } else {
        break;
      }
    }
    return v;
  }

  function parseExpr() {
    let v = parseTerm();
    while (true) {
      const c = peek();
      if (c === '+' || c === '-') {
        pos++;
        const rhs = parseTerm();
        if (c === '+') v = v + rhs;
        else v = v - rhs;
      } else {
        break;
      }
    }
    return v;
  }

  return parseExpr();
}

const rl = readline.createInterface({ input: process.stdin, terminal: false });
const out = [];
rl.on('line', (line) => {
  if (line.trim() === '' ) return;
  out.push(String(evaluate(line)));
});
rl.on('close', () => {
  process.stdout.write(out.join('\n') + (out.length ? '\n' : ''));
});
