#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(void) {
    long n;
    if (scanf("%ld", &n) != 1) {
        printf("\n");
        return 0;
    }
    if (n < 2) {
        printf("\n");
        return 0;
    }
    char *comp = calloc((size_t)n + 1, 1);
    if (!comp) return 1;
    for (long i = 2; i * i <= n; i++) {
        if (!comp[i]) {
            for (long j = i * i; j <= n; j += i) comp[j] = 1;
        }
    }
    int first = 1;
    for (long i = 2; i <= n; i++) {
        if (!comp[i]) {
            if (!first) putchar(' ');
            printf("%ld", i);
            first = 0;
        }
    }
    printf("\n");
    free(comp);
    return 0;
}
