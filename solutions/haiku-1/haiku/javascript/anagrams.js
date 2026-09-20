const readline = require('readline');

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
  terminal: false
});

const groups = new Map();

rl.on('line', (word) => {
  // Create a canonical form by sorting the letters
  const sorted = word.split('').sort().join('');

  if (!groups.has(sorted)) {
    groups.set(sorted, []);
  }
  groups.get(sorted).push(word);
});

rl.on('close', () => {
  // Convert to array of groups
  const groupsList = Array.from(groups.values());

  // Sort words within each group
  groupsList.forEach(group => {
    group.sort();
  });

  // Sort groups by their first word
  groupsList.sort((a, b) => a[0].localeCompare(b[0]));

  // Output
  groupsList.forEach(group => {
    console.log(group.join(' '));
  });
});
