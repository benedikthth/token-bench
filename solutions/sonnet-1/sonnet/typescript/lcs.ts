function main(input: string) {
  // Split into lines, handling both \n and \r\n, but preserve up to 2 lines
  // even if one or both are empty.
  const lines = input.split(/\r?\n/);
  const a = lines[0] ?? "";
  const b = lines[1] ?? "";

  const n = a.length;
  const m = b.length;

  let prev = new Uint32Array(m + 1);
  let curr = new Uint32Array(m + 1);

  for (let i = 1; i <= n; i++) {
    const ca = a.charCodeAt(i - 1);
    for (let j = 1; j <= m; j++) {
      if (ca === b.charCodeAt(j - 1)) {
        curr[j] = prev[j - 1] + 1;
      } else {
        curr[j] = prev[j] > curr[j - 1] ? prev[j] : curr[j - 1];
      }
    }
    const tmp = prev;
    prev = curr;
    curr = tmp;
  }

  console.log(prev[m].toString());
}

let input = "";
process.stdin.setEncoding("utf8");
process.stdin.on("data", (chunk) => {
  input += chunk;
});
process.stdin.on("end", () => {
  main(input);
});
