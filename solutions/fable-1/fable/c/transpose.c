#include <stdio.h>
#include <stdlib.h>

int main(void) {
    long r, c;
    if (scanf("%ld %ld", &r, &c) != 2) return 0;
    if (r <= 0 || c <= 0) return 0;
    long long *a = malloc(sizeof(long long) * (size_t)r * (size_t)c);
    if (!a) return 1;
    for (long i = 0; i < r; i++)
        for (long j = 0; j < c; j++)
            if (scanf("%lld", &a[i * c + j]) != 1) a[i * c + j] = 0;
    for (long j = 0; j < c; j++) {
        for (long i = 0; i < r; i++) {
            if (i) putchar(' ');
            printf("%lld", a[i * c + j]);
        }
        putchar('\n');
    }
    free(a);
    return 0;
}
