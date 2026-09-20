const s = require('fs').readFileSync(0, 'utf8').split('\n')[0].replace(/\r$/, '').trim();
let out = '';
for (let i = 0; i < s.length; ) {
  let j = i;
  while (j < s.length && s[j] === s[i]) j++;
  out += s[i] + (j - i);
  i = j;
}
process.stdout.write(out + '\n');
