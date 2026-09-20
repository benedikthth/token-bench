const readline = require('readline');

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
  terminal: false
});

const wordCounts = {};

rl.on('line', (line) => {
  // Extract words (maximal runs of ASCII letters)
  const words = line.match(/[a-zA-Z]+/g) || [];
  words.forEach(word => {
    const lowercase = word.toLowerCase();
    wordCounts[lowercase] = (wordCounts[lowercase] || 0) + 1;
  });
});

rl.on('close', () => {
  // Convert to array of [word, count] pairs and sort
  const sortedWords = Object.entries(wordCounts)
    .sort((a, b) => {
      // Sort by count descending, then by word ascending
      if (a[1] !== b[1]) {
        return b[1] - a[1]; // descending by count
      }
      return a[0].localeCompare(b[0]); // ascending by word
    });

  // Output
  sortedWords.forEach(([word, count]) => {
    console.log(`${word} ${count}`);
  });
});
