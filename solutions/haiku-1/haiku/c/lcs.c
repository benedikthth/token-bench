#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int main() {
    char s1[2001], s2[2001];

    // Read two lines
    if (fgets(s1, sizeof(s1), stdin) == NULL) {
        s1[0] = '\0';
    } else {
        // Remove newline if present
        int len = strlen(s1);
        if (len > 0 && s1[len-1] == '\n') {
            s1[len-1] = '\0';
        }
    }

    if (fgets(s2, sizeof(s2), stdin) == NULL) {
        s2[0] = '\0';
    } else {
        // Remove newline if present
        int len = strlen(s2);
        if (len > 0 && s2[len-1] == '\n') {
            s2[len-1] = '\0';
        }
    }

    int m = strlen(s1);
    int n = strlen(s2);

    // Create DP table
    int** dp = (int**)malloc((m+1) * sizeof(int*));
    for (int i = 0; i <= m; i++) {
        dp[i] = (int*)malloc((n+1) * sizeof(int));
        memset(dp[i], 0, (n+1) * sizeof(int));
    }

    // Fill DP table
    for (int i = 1; i <= m; i++) {
        for (int j = 1; j <= n; j++) {
            if (s1[i-1] == s2[j-1]) {
                dp[i][j] = dp[i-1][j-1] + 1;
            } else {
                dp[i][j] = (dp[i-1][j] > dp[i][j-1]) ? dp[i-1][j] : dp[i][j-1];
            }
        }
    }

    int result = dp[m][n];

    // Free memory
    for (int i = 0; i <= m; i++) {
        free(dp[i]);
    }
    free(dp);

    printf("%d\n", result);

    return 0;
}
