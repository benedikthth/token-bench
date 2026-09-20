#include <stdio.h>
#include <string.h>

static char composite[100001];

int main(void) {
    int n;
    if (scanf("%d", &n) != 1) n = 0;
    if (n < 0) n = 0;
    if (n > 100000) n = 100000;
    int first = 1;
    for (int i = 2; i <= n; i++) {
        if (composite[i]) continue;
        if (!first) putchar(' ');
        printf("%d", i);
        first = 0;
        for (long long j = (long long)i * i; j <= n; j += i) composite[j] = 1;
    }
    putchar('\n');
    return 0;
}
