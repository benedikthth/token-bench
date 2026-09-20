import { readFileSync } from "fs";

// Read all input from stdin
const input = readFileSync(0, "utf-8")
  .trim()
  .split("\n")
  .filter((line) => line.length > 0);

// Create a function to get anagram signature (sorted letters)
function getSignature(word: string): string {
  return word.split("").sort().join("");
}

// Group words by their anagram signature
const groups = new Map<string, string[]>();

for (const word of input) {
  const sig = getSignature(word);
  if (!groups.has(sig)) {
    groups.set(sig, []);
  }
  groups.get(sig)!.push(word);
}

// Sort words within each group and convert to result array
const result = Array.from(groups.values())
  .map((words) => {
    words.sort();
    return words;
  })
  .sort((a, b) => a[0].localeCompare(b[0]))
  .map((words) => words.join(" "));

// Output
console.log(result.join("\n"));
