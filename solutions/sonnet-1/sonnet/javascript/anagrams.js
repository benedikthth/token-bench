const lines = require('fs').readFileSync(0, 'utf8').split('\n').filter(w => w.length > 0);

const groups = new Map();
for (const word of lines) {
  const key = word.split('').sort().join('');
  if (!groups.has(key)) groups.set(key, []);
  groups.get(key).push(word);
}

const result = [];
for (const words of groups.values()) {
  words.sort();
  result.push(words);
}

result.sort((a, b) => (a[0] < b[0] ? -1 : a[0] > b[0] ? 1 : 0));

console.log(result.map(g => g.join(' ')).join('\n'));
