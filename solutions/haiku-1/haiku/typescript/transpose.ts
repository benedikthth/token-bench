import { readFileSync } from "fs";

const input = readFileSync(0, "utf-8");
const lines = input.trim().split("\n");

const [R, C] = lines[0].split(" ").map(Number);

// Read the matrix
const matrix: number[][] = [];
for (let i = 1; i <= R; i++) {
  const row = lines[i].split(" ").map(Number);
  matrix.push(row);
}

// Transpose the matrix
const transposed: number[][] = [];
for (let c = 0; c < C; c++) {
  const newRow: number[] = [];
  for (let r = 0; r < R; r++) {
    newRow.push(matrix[r][c]);
  }
  transposed.push(newRow);
}

// Output the transposed matrix
for (const row of transposed) {
  console.log(row.join(" "));
}
