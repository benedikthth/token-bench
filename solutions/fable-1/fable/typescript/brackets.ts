const input = await Bun.stdin.text();

const pairs: Record<string, string> = { ")": "(", "]": "[", "}": "{" };

function balanced(line: string): boolean {
  const stack: string[] = [];
  for (const ch of line) {
    if (ch === "(" || ch === "[" || ch === "{") {
      stack.push(ch);
    } else if (ch in pairs) {
      if (stack.pop() !== pairs[ch]) return false;
    } else if (ch === "\r") {
      continue;
    } else {
      return false;
    }
  }
  return stack.length === 0;
}

const lines = input.split("\n");
if (lines.length > 0 && lines[lines.length - 1] === "") lines.pop();

const out: string[] = [];
for (const line of lines) {
  out.push(balanced(line.replace(/\r$/, "")) ? "yes" : "no");
}
process.stdout.write(out.join("\n") + (out.length ? "\n" : ""));
