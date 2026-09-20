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
  const s1 = lines[0] || '';
  const s2 = lines[1] || '';

  const m = s1.length;
  const n = s2.length;

  // Create DP table where dp[i][j] represents the LCS length
  // of s1[0...i-1] and s2[0...j-1]
  const dp = Array(m + 1).fill(null).map(() => Array(n + 1).fill(0));

  // Fill DP table
  for (let i = 1; i <= m; i++) {
    for (let j = 1; j <= n; j++) {
      if (s1[i - 1] === s2[j - 1]) {
        // Characters match: extend the LCS from the previous state
        dp[i][j] = dp[i - 1][j - 1] + 1;
      } else {
        // Characters don't match: take the maximum LCS from either
        // excluding the current character from s1 or s2
        dp[i][j] = Math.max(dp[i - 1][j], dp[i][j - 1]);
      }
    }
  }

  console.log(dp[m][n]);
});
