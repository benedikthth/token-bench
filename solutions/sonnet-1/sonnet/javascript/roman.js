const lines = require('fs').readFileSync(0, 'utf8').split('\n');

const values = [
  [1000, 'M'], [900, 'CM'], [500, 'D'], [400, 'CD'],
  [100, 'C'], [90, 'XC'], [50, 'L'], [40, 'XL'],
  [10, 'X'], [9, 'IX'], [5, 'V'], [4, 'IV'],
  [1, 'I'],
];

function toRoman(num) {
  let result = '';
  for (const [value, symbol] of values) {
    while (num >= value) {
      result += symbol;
      num -= value;
    }
  }
  return result;
}

const output = [];
for (const line of lines) {
  const trimmed = line.trim();
  if (trimmed === '') continue;
  const num = parseInt(trimmed, 10);
  output.push(toRoman(num));
}

process.stdout.write(output.join('\n') + '\n');
