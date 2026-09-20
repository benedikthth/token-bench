const input = await Bun.stdin.text();
const line = input.split("\n")[0].replace(/\r$/, "");

let output = "";
let i = 0;
while (i < line.length) {
  const ch = line[i];
  let count = 0;
  while (i < line.length && line[i] === ch) {
    count++;
    i++;
  }
  output += ch + count;
}

console.log(output);
