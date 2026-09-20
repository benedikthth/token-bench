const input = await Bun.stdin.text();

const counts = new Map<string, number>();
const matches = input.match(/[A-Za-z]+/g) ?? [];
for (const raw of matches) {
  const word = raw.toLowerCase();
  counts.set(word, (counts.get(word) ?? 0) + 1);
}

const entries = [...counts.entries()];
entries.sort((a, b) => b[1] - a[1] || (a[0] < b[0] ? -1 : a[0] > b[0] ? 1 : 0));

const output = entries.map(([word, count]) => `${word} ${count}`).join("\n");
if (output.length > 0) {
  console.log(output);
}
