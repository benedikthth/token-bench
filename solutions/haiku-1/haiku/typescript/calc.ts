import { readFileSync } from "fs";

const input = readFileSync(0, "utf-8");
const lines = input.split("\n");

function evaluateExpression(expr: string): number {
  let pos = 0;

  function skipSpaces() {
    while (pos < expr.length && expr[pos] === " ") pos++;
  }

  function parseNumber(): number {
    skipSpaces();
    let num = 0;
    while (pos < expr.length && /[0-9]/.test(expr[pos])) {
      num = num * 10 + parseInt(expr[pos]);
      pos++;
    }
    return num;
  }

  function parsePrimary(): number {
    skipSpaces();
    if (pos < expr.length && expr[pos] === "(") {
      pos++; // skip '('
      const result = parseAddition();
      skipSpaces();
      pos++; // skip ')'
      return result;
    }
    return parseNumber();
  }

  function parseMultiplication(): number {
    let result = parsePrimary();
    while (true) {
      skipSpaces();
      if (
        pos >= expr.length ||
        (expr[pos] !== "*" && expr[pos] !== "/")
      ) {
        break;
      }
      const op = expr[pos];
      pos++;
      const right = parsePrimary();
      if (op === "*") {
        result = result * right;
      } else {
        // Integer division truncating toward zero
        result = Math.trunc(result / right);
      }
    }
    return result;
  }

  function parseAddition(): number {
    let result = parseMultiplication();
    while (true) {
      skipSpaces();
      if (
        pos >= expr.length ||
        (expr[pos] !== "+" && expr[pos] !== "-")
      ) {
        break;
      }
      const op = expr[pos];
      pos++;
      const right = parseMultiplication();
      if (op === "+") {
        result = result + right;
      } else {
        result = result - right;
      }
    }
    return result;
  }

  return parseAddition();
}

for (const line of lines) {
  const trimmed = line.trim();
  if (trimmed) {
    console.log(evaluateExpression(trimmed));
  }
}
