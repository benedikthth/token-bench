'use strict';

const data = require('fs').readFileSync(0, 'utf8');
const lines = data.split('\n').map((s) => s.replace(/\r$/, ''));
const a = lines[0] || '';
const b = lines[1] || '';

const n = a.length;
const m = b.length;

let prev = new Int32Array(m + 1);
let cur = new Int32Array(m + 1);

for (let i = 1; i <= n; i++) {
  const ai = a.charCodeAt(i - 1);
  for (let j = 1; j <= m; j++) {
    if (ai === b.charCodeAt(j - 1)) {
      cur[j] = prev[j - 1] + 1;
    } else {
      cur[j] = prev[j] > cur[j - 1] ? prev[j] : cur[j - 1];
    }
  }
  const tmp = prev;
  prev = cur;
  cur = tmp;
}

process.stdout.write(String(prev[m]) + '\n');
