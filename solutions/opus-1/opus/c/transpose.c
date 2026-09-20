#include <stdio.h>
#include <stdlib.h>

int main(void) {
    long r, c;
    if (scanf("%ld %ld", &r, &c) != 2) return 0;
    long long *m = malloc(sizeof(long long) * (size_t)(r * c > 0 ? r * c : 1));
    for (long i = 0; i < r * c; i++) {
        if (scanf("%lld", &m[i]) != 1) m[i] = 0;
    }
    for (long j = 0; j < c; j++) {
        for (long i = 0; i < r; i++) {
            if (i) putchar(' ');
            printf("%lld", m[i * c + j]);
        }
        putchar('\n');
    }
    free(m);
    return 0;
}
