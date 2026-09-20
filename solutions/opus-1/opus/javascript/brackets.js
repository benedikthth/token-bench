const data = require('fs').readFileSync(0, 'utf8');
const lines = data.split('\n');
if (lines.length > 1 && lines[lines.length - 1] === '') lines.pop();
const pairs = { ')': '(', ']': '[', '}': '{' };
const out = [];
for (const raw of lines) {
  const line = raw.replace(/\r$/, '');
  const stack = [];
  let ok = true;
  for (const c of line) {
    if (c === '(' || c === '[' || c === '{') stack.push(c);
    else if (c in pairs) {
      if (stack.pop() !== pairs[c]) { ok = false; break; }
    }
  }
  out.push(ok && stack.length === 0 ? 'yes' : 'no');
}
process.stdout.write(out.join('\n') + '\n');
