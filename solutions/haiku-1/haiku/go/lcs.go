package main

import (
	"bufio"
	"fmt"
	"os"
)

func main() {
	scanner := bufio.NewScanner(os.Stdin)

	var line1, line2 string
	if scanner.Scan() {
		line1 = scanner.Text()
	}
	if scanner.Scan() {
		line2 = scanner.Text()
	}

	fmt.Println(lcs(line1, line2))
}

func lcs(a, b string) int {
	m := len(a)
	n := len(b)

	// Create DP table: dp[i][j] = length of LCS of a[0:i] and b[0:j]
	dp := make([][]int, m+1)
	for i := range dp {
		dp[i] = make([]int, n+1)
	}

	// Fill the DP table
	for i := 1; i <= m; i++ {
		for j := 1; j <= n; j++ {
			if a[i-1] == b[j-1] {
				// Characters match, extend the LCS
				dp[i][j] = dp[i-1][j-1] + 1
			} else {
				// Characters don't match, take the maximum of excluding one character
				if dp[i-1][j] > dp[i][j-1] {
					dp[i][j] = dp[i-1][j]
				} else {
					dp[i][j] = dp[i][j-1]
				}
			}
		}
	}

	return dp[m][n]
}
