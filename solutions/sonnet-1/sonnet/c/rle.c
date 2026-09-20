#include <stdio.h>

int main(void) {
    int c;
    int prev = -1;
    long count = 0;

    while ((c = getchar()) != EOF) {
        if (c == '\n' || c == '\r') {
            break;
        }
        if (c == prev) {
            count++;
        } else {
            if (prev != -1) {
                printf("%c%ld", prev, count);
            }
            prev = c;
            count = 1;
        }
    }

    if (prev != -1) {
        printf("%c%ld", prev, count);
    }

    printf("\n");
    return 0;
}
