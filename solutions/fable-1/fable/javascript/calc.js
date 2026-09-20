'use strict';

const input = require('fs').readFileSync(0, 'utf8');

function evaluate(s) {
  let pos = 0;

  function skipSpaces() {
    while (pos < s.length && /\s/.test(s[pos])) pos++;
  }

  function parseNumber() {
    skipSpaces();
    let start = pos;
    while (pos < s.length && s[pos] >= '0' && s[pos] <= '9') pos++;
    return BigInt(s.slice(start, pos));
  }

  function parseFactor() {
    skipSpaces();
    if (s[pos] === '(') {
      pos++;
      const v = parseExpr();
      skipSpaces();
      if (s[pos] === ')') pos++;
      return v;
    }
    return parseNumber();
  }

  function parseTerm() {
    let v = parseFactor();
    for (;;) {
      skipSpaces();
      const c = s[pos];
      if (c === '*') {
        pos++;
        v = v * parseFactor();
      } else if (c === '/') {
        pos++;
        v = v / parseFactor(); // BigInt division truncates toward zero
      } else {
        return v;
      }
    }
  }

  function parseExpr() {
    let v = parseTerm();
    for (;;) {
      skipSpaces();
      const c = s[pos];
      if (c === '+') {
        pos++;
        v = v + parseTerm();
      } else if (c === '-') {
        pos++;
        v = v - parseTerm();
      } else {
        return v;
      }
    }
  }

  return parseExpr();
}

const out = [];
for (const rawLine of input.split('\n')) {
  const line = rawLine.replace(/\r$/, '');
  if (line.trim() === '') continue;
  out.push(evaluate(line).toString());
}
process.stdout.write(out.join('\n') + (out.length ? '\n' : ''));
