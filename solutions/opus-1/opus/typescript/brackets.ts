const input = await Bun.stdin.text();
const lines = input.split("\n");
if (lines.length > 0 && lines[lines.length - 1] === "") lines.pop();

const pairs: Record<string, string> = { ")": "(", "]": "[", "}": "{" };
const out: string[] = [];

for (const raw of lines) {
  const line = raw.trim();
  const stack: string[] = [];
  let ok = true;
  for (const ch of line) {
    if (ch === "(" || ch === "[" || ch === "{") {
      stack.push(ch);
    } else if (ch in pairs) {
      if (stack.pop() !== pairs[ch]) {
        ok = false;
        break;
      }
    }
  }
  out.push(ok && stack.length === 0 ? "yes" : "no");
}

process.stdout.write(out.length ? out.join("\n") + "\n" : "");
