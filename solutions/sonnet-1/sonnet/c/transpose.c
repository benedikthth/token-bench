#include <stdio.h>
#include <stdlib.h>

int main(void) {
    int r, c;
    if (scanf("%d %d", &r, &c) != 2) return 0;

    long long *a = malloc((size_t)r * c * sizeof(long long));
    for (int i = 0; i < r; i++) {
        for (int j = 0; j < c; j++) {
            scanf("%lld", &a[(size_t)i * c + j]);
        }
    }

    for (int j = 0; j < c; j++) {
        for (int i = 0; i < r; i++) {
            printf("%lld%s", a[(size_t)i * c + j], (i + 1 < r) ? " " : "\n");
        }
    }

    free(a);
    return 0;
}
