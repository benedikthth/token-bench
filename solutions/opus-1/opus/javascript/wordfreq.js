const data = require('fs').readFileSync(0, 'latin1');
const counts = new Map();
for (const m of data.matchAll(/[A-Za-z]+/g)) {
  const w = m[0].toLowerCase();
  counts.set(w, (counts.get(w) || 0) + 1);
}
const entries = [...counts];
entries.sort((a, b) => b[1] - a[1] || (a[0] < b[0] ? -1 : a[0] > b[0] ? 1 : 0));
process.stdout.write(entries.map(([w, c]) => `${w} ${c}\n`).join(''));
