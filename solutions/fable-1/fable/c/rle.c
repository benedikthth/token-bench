#include <stdio.h>

int main(void) {
    int prev = -1;
    long count = 0;
    int c;
    while ((c = getchar()) != EOF) {
        if (c < 'a' || c > 'z') {
            if (c == '\n') break;
            continue;
        }
        if (c == prev) {
            count++;
        } else {
            if (prev != -1) printf("%c%ld", prev, count);
            prev = c;
            count = 1;
        }
    }
    if (prev != -1) printf("%c%ld", prev, count);
    putchar('\n');
    return 0;
}
