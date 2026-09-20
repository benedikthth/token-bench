const readline = require('readline');

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
  terminal: false
});

rl.on('line', (line) => {
  if (line.length === 0) {
    console.log('');
    rl.close();
    return;
  }

  let result = '';
  let i = 0;

  while (i < line.length) {
    let char = line[i];
    let count = 1;

    // Count consecutive occurrences of the current character
    while (i + count < line.length && line[i + count] === char) {
      count++;
    }

    result += char + count;
    i += count;
  }

  console.log(result);
  rl.close();
});
