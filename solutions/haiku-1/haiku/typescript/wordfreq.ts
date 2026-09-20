import { readFileSync } from "fs";

const input = readFileSync(0, "utf-8");

// Extract all words (maximal runs of ASCII letters) and count them
const wordCount: Record<string, number> = {};

const matches = input.match(/[a-zA-Z]+/g) || [];
for (const word of matches) {
  const lowerWord = word.toLowerCase();
  wordCount[lowerWord] = (wordCount[lowerWord] || 0) + 1;
}

// Convert to array and sort
const sorted = Object.entries(wordCount).sort((a, b) => {
  // Sort by count descending
  if (a[1] !== b[1]) {
    return b[1] - a[1];
  }
  // Then by word ascending
  return a[0].localeCompare(b[0]);
});

// Output
for (const [word, count] of sorted) {
  console.log(`${word} ${count}`);
}
