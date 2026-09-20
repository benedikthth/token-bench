const data = require('fs').readFileSync(0, 'utf8');
const words = data.split(/\s+/).filter(w => w.length > 0);
const cmp = (a, b) => (a < b ? -1 : a > b ? 1 : 0);
const groups = new Map();
for (const w of words) {
  const key = w.split('').sort().join('');
  if (!groups.has(key)) groups.set(key, []);
  groups.get(key).push(w);
}
const out = [...groups.values()].map(g => g.sort(cmp));
out.sort((a, b) => cmp(a[0], b[0]));
process.stdout.write(out.map(g => g.join(' ') + '\n').join(''));
