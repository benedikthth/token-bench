#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(void) {
    long n;
    if (scanf("%ld", &n) != 1) {
        return 0;
    }
    if (n < 2) {
        printf("\n");
        return 0;
    }

    char *is_composite = calloc((size_t)n + 1, 1);
    int first = 1;
    for (long i = 2; i <= n; i++) {
        if (!is_composite[i]) {
            if (!first) {
                putchar(' ');
            }
            printf("%ld", i);
            first = 0;
            for (long j = i * i; j <= n && j > 0; j += i) {
                is_composite[j] = 1;
            }
        }
    }
    printf("\n");
    free(is_composite);
    return 0;
}
