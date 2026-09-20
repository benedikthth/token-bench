const readline = require('readline');

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
  terminal: false
});

const lines = [];

rl.on('line', (line) => {
  lines.push(line);
});

rl.on('close', () => {
  const [R, C] = lines[0].split(' ').map(Number);

  // Parse the matrix
  const matrix = [];
  for (let i = 1; i <= R; i++) {
    const row = lines[i].split(' ').map(Number);
    matrix.push(row);
  }

  // Transpose: for each column, create a new row
  const transposed = [];
  for (let c = 0; c < C; c++) {
    const newRow = [];
    for (let r = 0; r < R; r++) {
      newRow.push(matrix[r][c]);
    }
    transposed.push(newRow);
  }

  // Output the transposed matrix
  for (const row of transposed) {
    console.log(row.join(' '));
  }
});
