const lines = require('fs').readFileSync('/dev/stdin', 'utf8').split('\n');
const a = (lines[0] || '').replace(/\r$/, '');
const b = (lines[1] || '').replace(/\r$/, '');

const n = a.length;
const m = b.length;

let prev = new Array(m + 1).fill(0);
let curr = new Array(m + 1).fill(0);

for (let i = 1; i <= n; i++) {
  const ca = a.charCodeAt(i - 1);
  for (let j = 1; j <= m; j++) {
    if (ca === b.charCodeAt(j - 1)) {
      curr[j] = prev[j - 1] + 1;
    } else {
      curr[j] = prev[j] > curr[j - 1] ? prev[j] : curr[j - 1];
    }
  }
  [prev, curr] = [curr, prev];
}

console.log(prev[m]);
