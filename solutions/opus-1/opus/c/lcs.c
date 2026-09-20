#include <stdio.h>
#include <string.h>

static char a[4096], b[4096];
static int dp[4096];

static int readline(char *s, int cap) {
    if (!fgets(s, cap, stdin)) { s[0] = 0; return 0; }
    int n = (int)strlen(s);
    while (n > 0 && (s[n-1] == '\n' || s[n-1] == '\r' || s[n-1] == ' ' || s[n-1] == '\t')) s[--n] = 0;
    return n;
}

int main(void) {
    int n = readline(a, sizeof a);
    int m = readline(b, sizeof b);
    memset(dp, 0, sizeof dp);
    for (int i = 1; i <= n; i++) {
        int prev = 0; /* dp[i-1][j-1] */
        for (int j = 1; j <= m; j++) {
            int tmp = dp[j];
            if (a[i-1] == b[j-1]) dp[j] = prev + 1;
            else if (dp[j-1] > dp[j]) dp[j] = dp[j-1];
            prev = tmp;
        }
    }
    printf("%d\n", dp[m]);
    return 0;
}
