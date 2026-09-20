#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static const char *p;

static void skip(void) { while (*p == ' ' || *p == '\t' || *p == '\r') p++; }

static long long expr(void);

static long long factor(void) {
    skip();
    if (*p == '(') {
        p++;
        long long v = expr();
        skip();
        if (*p == ')') p++;
        return v;
    }
    long long v = 0;
    while (*p >= '0' && *p <= '9') {
        v = v * 10 + (*p - '0');
        p++;
    }
    return v;
}

static long long term(void) {
    long long v = factor();
    for (;;) {
        skip();
        if (*p == '*') { p++; v *= factor(); }
        else if (*p == '/') { p++; long long d = factor(); v = d ? v / d : 0; }
        else return v;
    }
}

static long long expr(void) {
    long long v = term();
    for (;;) {
        skip();
        if (*p == '+') { p++; v += term(); }
        else if (*p == '-') { p++; v -= term(); }
        else return v;
    }
}

int main(void) {
    static char line[1 << 20];
    while (fgets(line, sizeof line, stdin)) {
        p = line;
        skip();
        if (*p == '\0' || *p == '\n') continue;
        long long v = expr();
        printf("%lld\n", v);
    }
    return 0;
}
