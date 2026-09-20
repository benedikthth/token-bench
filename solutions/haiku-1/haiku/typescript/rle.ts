import { readFileSync } from "fs";

const input = readFileSync(0, "utf-8").trim();

let result = "";
let i = 0;
while (i < input.length) {
  const char = input[i];
  let count = 1;
  while (i + count < input.length && input[i + count] === char) {
    count++;
  }
  result += char + count;
  i += count;
}
console.log(result);
