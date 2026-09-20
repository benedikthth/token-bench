#include <stdio.h>

int main(void) {
    int values[] = {1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1};
    const char *symbols[] = {"M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"};
    int n;
    while (scanf("%d", &n) == 1) {
        for (int i = 0; i < 13; i++) {
            while (n >= values[i]) {
                n -= values[i];
                fputs(symbols[i], stdout);
            }
        }
        putchar('\n');
    }
    return 0;
}
