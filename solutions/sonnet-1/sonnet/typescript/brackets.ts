function isBalanced(line: string): boolean {
  const stack: string[] = [];
  const opens = new Set(["(", "[", "{"]);
  const closesTo: Record<string, string> = { ")": "(", "]": "[", "}": "{" };
  for (const ch of line) {
    if (opens.has(ch)) {
      stack.push(ch);
    } else if (ch in closesTo) {
      const top = stack.pop();
      if (top !== closesTo[ch]) return false;
    }
  }
  return stack.length === 0;
}

async function main() {
  const input = await Bun.stdin.text();
  const lines = input.split("\n");
  // Remove a single trailing empty line caused by trailing newline in input
  if (lines.length > 0 && lines[lines.length - 1] === "") {
    lines.pop();
  }
  const output = lines.map((line) => {
    const trimmed = line.replace(/\r$/, "");
    return isBalanced(trimmed) ? "yes" : "no";
  });
  console.log(output.join("\n"));
}

main();
