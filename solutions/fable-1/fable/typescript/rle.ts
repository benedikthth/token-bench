const input = await Bun.stdin.text();
const s = input.replace(/\r?\n[\s\S]*$/, "").trim();

let out = "";
let i = 0;
while (i < s.length) {
  const c = s[i];
  let j = i;
  while (j < s.length && s[j] === c) j++;
  out += c + (j - i);
  i = j;
}

process.stdout.write(out + (out.length > 0 ? "\n" : ""));
