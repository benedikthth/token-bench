import { readFileSync } from "fs";

const input = readFileSync(0, "utf-8").split(/\r?\n/);
const s1 = input[0] || "";
const s2 = input[1] || "";

const m = s1.length;
const n = s2.length;

// DP table where dp[i][j] = length of LCS of s1[0..i-1] and s2[0..j-1]
const dp: number[][] = Array(m + 1)
  .fill(null)
  .map(() => Array(n + 1).fill(0));

// Fill the DP table
for (let i = 1; i <= m; i++) {
  for (let j = 1; j <= n; j++) {
    if (s1[i - 1] === s2[j - 1]) {
      dp[i][j] = dp[i - 1][j - 1] + 1;
    } else {
      dp[i][j] = Math.max(dp[i - 1][j], dp[i][j - 1]);
    }
  }
}

console.log(dp[m][n]);
