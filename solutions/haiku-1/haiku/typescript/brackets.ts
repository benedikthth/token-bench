import { createInterface } from "readline";
import { stdin } from "process";

function isBalanced(line: string): boolean {
  const stack: string[] = [];

  for (const char of line) {
    if (char === "(" || char === "[" || char === "{") {
      stack.push(char);
    } else if (char === ")" || char === "]" || char === "}") {
      if (stack.length === 0) {
        return false;
      }

      const opening = stack.pop()!;

      if (
        (char === ")" && opening !== "(") ||
        (char === "]" && opening !== "[") ||
        (char === "}" && opening !== "{")
      ) {
        return false;
      }
    }
  }

  return stack.length === 0;
}

const rl = createInterface({
  input: stdin,
  terminal: false,
});

rl.on("line", (line: string) => {
  console.log(isBalanced(line) ? "yes" : "no");
});
