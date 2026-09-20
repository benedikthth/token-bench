const input = await Bun.stdin.text();
const out: string[] = [];

for (const raw of input.split("\n")) {
  const line = raw.replace(/\r$/, "");
  if (line.trim() === "") continue;
  const toks = line.match(/\d+|[-+*/()]/g) ?? [];
  let pos = 0;

  const parsePrimary = (): bigint => {
    const t = toks[pos++];
    if (t === "(") {
      const v = parseExpr();
      pos++; // ')'
      return v;
    }
    return BigInt(t);
  };

  const parseTerm = (): bigint => {
    let v = parsePrimary();
    while (pos < toks.length && (toks[pos] === "*" || toks[pos] === "/")) {
      const op = toks[pos++];
      const r = parsePrimary();
      v = op === "*" ? v * r : v / r;
    }
    return v;
  };

  const parseExpr = (): bigint => {
    let v = parseTerm();
    while (pos < toks.length && (toks[pos] === "+" || toks[pos] === "-")) {
      const op = toks[pos++];
      const r = parseTerm();
      v = op === "+" ? v + r : v - r;
    }
    return v;
  };

  out.push(parseExpr().toString());
}

process.stdout.write(out.length ? out.join("\n") + "\n" : "");
