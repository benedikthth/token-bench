# Read input
line1 = input()
line2 = input()

m, n = len(line1), len(line2)

# Create DP table where dp[i][j] = LCS length of line1[0:i] and line2[0:j]
dp = [[0] * (n + 1) for _ in range(m + 1)]

# Fill DP table
for i in range(1, m + 1):
    for j in range(1, n + 1):
        if line1[i - 1] == line2[j - 1]:
            # Characters match: add 1 to the LCS of previous prefixes
            dp[i][j] = dp[i - 1][j - 1] + 1
        else:
            # Characters don't match: take max from either direction
            dp[i][j] = max(dp[i - 1][j], dp[i][j - 1])

# Output the length of the longest common subsequence
print(dp[m][n])
