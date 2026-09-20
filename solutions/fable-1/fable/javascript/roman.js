const fs = require('fs');

const PAIRS = [
  [1000, 'M'], [900, 'CM'], [500, 'D'], [400, 'CD'],
  [100, 'C'], [90, 'XC'], [50, 'L'], [40, 'XL'],
  [10, 'X'], [9, 'IX'], [5, 'V'], [4, 'IV'], [1, 'I'],
];

function toRoman(n) {
  let out = '';
  for (const [value, sym] of PAIRS) {
    while (n >= value) {
      out += sym;
      n -= value;
    }
  }
  return out;
}

const input = fs.readFileSync(0, 'utf8');
const lines = input.split(/\r?\n/);
const result = [];
for (const line of lines) {
  const t = line.trim();
  if (t === '') continue;
  result.push(toRoman(parseInt(t, 10)));
}
process.stdout.write(result.join('\n') + (result.length ? '\n' : ''));
