const input = require('fs').readFileSync(0, 'utf8');
const s = input.split(/\r?\n/)[0] || '';
let out = '';
let i = 0;
while (i < s.length) {
  let j = i;
  while (j < s.length && s[j] === s[i]) j++;
  out += s[i] + (j - i);
  i = j;
}
process.stdout.write(out + '\n');
