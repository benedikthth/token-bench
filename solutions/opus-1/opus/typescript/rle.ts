const data = await Bun.stdin.text();
const s = (data.split("\n")[0] ?? "").replace(/\r$/, "").trim();
let out = "";
let i = 0;
while (i < s.length) {
  let j = i;
  while (j < s.length && s[j] === s[i]) j++;
  out += s[i] + (j - i);
  i = j;
}
process.stdout.write(out + "\n");
