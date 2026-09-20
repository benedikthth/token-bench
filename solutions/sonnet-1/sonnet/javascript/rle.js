const line = require('fs').readFileSync(0, 'utf8').split('\n')[0].replace(/\r$/, '');

let output = '';
let i = 0;
while (i < line.length) {
  let j = i;
  while (j < line.length && line[j] === line[i]) j++;
  output += line[i] + (j - i);
  i = j;
}

console.log(output);
