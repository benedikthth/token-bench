const data = require('fs').readFileSync(0, 'utf8');
const counts = new Map();
const words = data.match(/[A-Za-z]+/g) || [];
for (const w of words) {
  const lw = w.toLowerCase();
  counts.set(lw, (counts.get(lw) || 0) + 1);
}
const entries = [...counts.entries()];
entries.sort((a, b) => b[1] - a[1] || (a[0] < b[0] ? -1 : a[0] > b[0] ? 1 : 0));
const out = entries.map(([w, c]) => `${w} ${c}`).join('\n');
process.stdout.write(out + (out ? '\n' : ''));
