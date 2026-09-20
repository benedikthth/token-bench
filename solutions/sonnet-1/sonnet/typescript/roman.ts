const VALUES: [number, string][] = [
  [1000, "M"],
  [900, "CM"],
  [500, "D"],
  [400, "CD"],
  [100, "C"],
  [90, "XC"],
  [50, "L"],
  [40, "XL"],
  [10, "X"],
  [9, "IX"],
  [5, "V"],
  [4, "IV"],
  [1, "I"],
];

function toRoman(num: number): string {
  let result = "";
  for (const [value, symbol] of VALUES) {
    while (num >= value) {
      result += symbol;
      num -= value;
    }
  }
  return result;
}

const input = require("fs").readFileSync(0, "utf-8");
const lines = input.split(/\r?\n/).filter((line: string) => line.trim() !== "");
const output = lines.map((line: string) => toRoman(parseInt(line.trim(), 10)));
console.log(output.join("\n"));
