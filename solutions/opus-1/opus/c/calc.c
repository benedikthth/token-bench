#include <stdio.h>
#include <string.h>
#include <ctype.h>

static const char *p;

static void skip(void) { while (*p == ' ' || *p == '\t') p++; }

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
    while (isdigit((unsigned char)*p)) v = v * 10 + (*p++ - '0');
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

static char line[1 << 20];

int main(void) {
    while (fgets(line, sizeof line, stdin)) {
        size_t n = strlen(line);
        while (n && (line[n-1] == '\n' || line[n-1] == '\r' || line[n-1] == ' ' || line[n-1] == '\t')) line[--n] = 0;
        p = line;
        skip();
        if (!*p) continue;
        printf("%lld\n", expr());
    }
    return 0;
}
