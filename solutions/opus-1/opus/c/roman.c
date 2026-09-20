#include <stdio.h>

int main(void) {
    static const int vals[] = {1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1};
    static const char *syms[] = {"M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"};
    int n;
    while (scanf("%d", &n) == 1) {
        char buf[64];
        int len = 0;
        for (int i = 0; i < 13; i++) {
            while (n >= vals[i]) {
                for (const char *s = syms[i]; *s; s++) buf[len++] = *s;
                n -= vals[i];
            }
        }
        buf[len++] = '\n';
        fwrite(buf, 1, len, stdout);
    }
    return 0;
}
