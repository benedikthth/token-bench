#include <stdio.h>

int main(void) {
    int c, prev = -1;
    long count = 0;
    while ((c = getchar()) != EOF && c != '\n') {
        if (c < 'a' || c > 'z') continue;
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
