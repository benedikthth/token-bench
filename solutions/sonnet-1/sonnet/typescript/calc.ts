class Parser {
  private s: string;
  private i: number = 0;

  constructor(s: string) {
    this.s = s;
  }

  private skipSpaces(): void {
    while (this.i < this.s.length && this.s[this.i] === " ") this.i++;
  }

  private peek(): string {
    this.skipSpaces();
    return this.i < this.s.length ? this.s[this.i] : "";
  }

  parseExpr(): number {
    let value = this.parseTerm();
    while (true) {
      const c = this.peek();
      if (c === "+" || c === "-") {
        this.i++;
        const rhs = this.parseTerm();
        value = c === "+" ? value + rhs : value - rhs;
      } else {
        break;
      }
    }
    return value;
  }

  private parseTerm(): number {
    let value = this.parseFactor();
    while (true) {
      const c = this.peek();
      if (c === "*" || c === "/") {
        this.i++;
        const rhs = this.parseFactor();
        if (c === "*") {
          value = value * rhs;
        } else {
          value = Math.trunc(value / rhs);
        }
      } else {
        break;
      }
    }
    return value;
  }

  private parseFactor(): number {
    const c = this.peek();
    if (c === "(") {
      this.i++;
      const value = this.parseExpr();
      this.skipSpaces();
      if (this.peek() === ")") this.i++;
      return value;
    }
    return this.parseNumber();
  }

  private parseNumber(): number {
    this.skipSpaces();
    let start = this.i;
    while (this.i < this.s.length && this.s[this.i] >= "0" && this.s[this.i] <= "9") {
      this.i++;
    }
    return parseInt(this.s.slice(start, this.i), 10);
  }
}

function evaluate(line: string): number {
  const parser = new Parser(line);
  return parser.parseExpr();
}

async function main() {
  const chunks: Buffer[] = [];
  for await (const chunk of process.stdin) {
    chunks.push(chunk as Buffer);
  }
  const input = Buffer.concat(chunks).toString("utf8");
  const lines = input.split(/\r?\n/);
  const output: string[] = [];
  for (const line of lines) {
    if (line.trim() === "") continue;
    output.push(String(evaluate(line)));
  }
  console.log(output.join("\n"));
}

main();
