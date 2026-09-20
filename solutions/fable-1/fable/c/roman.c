#include <stdio.h>

int main(void) {
    static const int vals[] = {1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1};
    static const char *syms[] = {"M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"};
    int n;
    while (scanf("%d", &n) == 1) {
        char buf[32];
        int len = 0;
        for (int i = 0; i < 13; i++) {
            while (n >= vals[i]) {
                for (const char *p = syms[i]; *p; p++) buf[len++] = *p;
                n -= vals[i];
            }
        }
        buf[len] = '\0';
        puts(buf);
    }
    return 0;
}
