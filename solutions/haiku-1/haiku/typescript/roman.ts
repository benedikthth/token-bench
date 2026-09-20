import { readFileSync } from 'fs';

const romanValues = [
  { value: 1000, numeral: 'M' },
  { value: 900, numeral: 'CM' },
  { value: 500, numeral: 'D' },
  { value: 400, numeral: 'CD' },
  { value: 100, numeral: 'C' },
  { value: 90, numeral: 'XC' },
  { value: 50, numeral: 'L' },
  { value: 40, numeral: 'XL' },
  { value: 10, numeral: 'X' },
  { value: 9, numeral: 'IX' },
  { value: 5, numeral: 'V' },
  { value: 4, numeral: 'IV' },
  { value: 1, numeral: 'I' },
];

function intToRoman(num: number): string {
  let result = '';
  for (const { value, numeral } of romanValues) {
    while (num >= value) {
      result += numeral;
      num -= value;
    }
  }
  return result;
}

const input = readFileSync(0, 'utf-8');
const lines = input.trim().split('\n');
for (const line of lines) {
  const num = parseInt(line, 10);
  if (num > 0) {
    console.log(intToRoman(num));
  }
}
