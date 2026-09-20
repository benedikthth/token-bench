const lines = require('fs').readFileSync(0, 'utf8').split('\n');

if (lines.length > 0 && lines[lines.length - 1] === '') {
  lines.pop();
}

const pairs = { ')': '(', ']': '[', '}': '{' };
const openers = new Set(['(', '[', '{']);

const results = lines.map((line) => {
  const stack = [];
  for (const ch of line) {
    if (openers.has(ch)) {
      stack.push(ch);
    } else if (pairs[ch]) {
      if (stack.pop() !== pairs[ch]) return 'no';
    }
  }
  return stack.length === 0 ? 'yes' : 'no';
});

console.log(results.join('\n'));
