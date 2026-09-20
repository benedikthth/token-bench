const input = require("fs").readFileSync(0, "utf8") as string;

function evaluate(s: string): bigint {
  let pos = 0;

  function skipSpaces(): void {
    while (pos < s.length && (s[pos] === " " || s[pos] === "\t" || s[pos] === "\r")) pos++;
  }

  function parseExpr(): bigint {
    let value = parseTerm();
    while (true) {
      skipSpaces();
      const c = s[pos];
      if (c === "+") {
        pos++;
        value += parseTerm();
      } else if (c === "-") {
        pos++;
        value -= parseTerm();
      } else {
        return value;
      }
    }
  }

  function parseTerm(): bigint {
    let value = parseFactor();
    while (true) {
      skipSpaces();
      const c = s[pos];
      if (c === "*") {
        pos++;
        value *= parseFactor();
      } else if (c === "/") {
        pos++;
        const rhs = parseFactor();
        // BigInt division truncates toward zero.
        value = value / rhs;
      } else {
        return value;
      }
    }
  }

  function parseFactor(): bigint {
    skipSpaces();
    const c = s[pos];
    if (c === "(") {
      pos++;
      const value = parseExpr();
      skipSpaces();
      if (s[pos] === ")") pos++;
      return value;
    }
    const start = pos;
    while (pos < s.length && s[pos] >= "0" && s[pos] <= "9") pos++;
    if (start === pos) {
      // Malformed input; treat as 0 and advance to avoid infinite loops.
      pos++;
      return 0n;
    }
    return BigInt(s.slice(start, pos));
  }

  return parseExpr();
}

const out: string[] = [];
for (const rawLine of input.split("\n")) {
  const line = rawLine.replace(/\r$/, "");
  if (line.trim() === "") continue;
  out.push(evaluate(line).toString());
}
process.stdout.write(out.join("\n") + (out.length ? "\n" : ""));
