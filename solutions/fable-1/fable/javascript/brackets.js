const data = require('fs').readFileSync(0, 'utf8');
const lines = data.split('\n');
if (lines.length && lines[lines.length - 1] === '') lines.pop();

const pairs = { ')': '(', ']': '[', '}': '{' };
const out = [];

for (let raw of lines) {
  const line = raw.replace(/\r$/, '');
  const stack = [];
  let ok = true;
  for (const ch of line) {
    if (ch === '(' || ch === '[' || ch === '{') {
      stack.push(ch);
    } else if (ch in pairs) {
      if (stack.pop() !== pairs[ch]) { ok = false; break; }
    } else {
      ok = false;
      break;
    }
  }
  out.push(ok && stack.length === 0 ? 'yes' : 'no');
}

process.stdout.write(out.join('\n') + (out.length ? '\n' : ''));
