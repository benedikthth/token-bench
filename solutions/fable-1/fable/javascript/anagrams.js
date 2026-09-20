const fs = require('fs');

const input = fs.readFileSync(0, 'utf8');
const words = input.split(/\r?\n/).filter((w) => w.length > 0);

const groups = new Map();
for (const w of words) {
  const key = w.split('').sort().join('');
  if (!groups.has(key)) groups.set(key, []);
  groups.get(key).push(w);
}

const result = [];
for (const g of groups.values()) {
  g.sort();
  result.push(g);
}
result.sort((a, b) => (a[0] < b[0] ? -1 : a[0] > b[0] ? 1 : 0));

process.stdout.write(result.map((g) => g.join(' ')).join('\n') + (result.length ? '\n' : ''));
