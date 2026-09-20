use std::io;

fn main() {
    let mut line1 = String::new();
    let mut line2 = String::new();

    io::stdin().read_line(&mut line1).unwrap();
    io::stdin().read_line(&mut line2).unwrap();

    // Remove newlines and convert to bytes for efficient access
    let s1: Vec<u8> = line1.trim_end().as_bytes().to_vec();
    let s2: Vec<u8> = line2.trim_end().as_bytes().to_vec();

    let m = s1.len();
    let n = s2.len();

    // Create DP table: dp[i][j] = length of LCS of s1[0..i] and s2[0..j]
    let mut dp = vec![vec![0; n + 1]; m + 1];

    // Fill DP table using LCS recurrence relation
    for i in 1..=m {
        for j in 1..=n {
            if s1[i - 1] == s2[j - 1] {
                // Characters match: extend the LCS
                dp[i][j] = dp[i - 1][j - 1] + 1;
            } else {
                // Characters don't match: take the maximum from previous states
                dp[i][j] = std::cmp::max(dp[i - 1][j], dp[i][j - 1]);
            }
        }
    }

    println!("{}", dp[m][n]);
}
