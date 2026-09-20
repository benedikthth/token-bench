#include <stdio.h>
#include <string.h>
#include <ctype.h>

static const char *p;

static long long parseExpr(void);

static void skipSpaces(void) {
    while (*p == ' ') p++;
}

static long long parseFactor(void) {
    skipSpaces();
    if (*p == '(') {
        p++;
        long long v = parseExpr();
        skipSpaces();
        if (*p == ')') p++;
        return v;
    }
    long long v = 0;
    skipSpaces();
    while (isdigit((unsigned char)*p)) {
        v = v * 10 + (*p - '0');
        p++;
    }
    return v;
}

static long long parseTerm(void) {
    long long v = parseFactor();
    for (;;) {
        skipSpaces();
        if (*p == '*') {
            p++;
            long long rhs = parseFactor();
            v = v * rhs;
        } else if (*p == '/') {
            p++;
            long long rhs = parseFactor();
            v = v / rhs;
        } else {
            break;
        }
    }
    return v;
}

static long long parseExpr(void) {
    long long v = parseTerm();
    for (;;) {
        skipSpaces();
        if (*p == '+') {
            p++;
            long long rhs = parseTerm();
            v = v + rhs;
        } else if (*p == '-') {
            p++;
            long long rhs = parseTerm();
            v = v - rhs;
        } else {
            break;
        }
    }
    return v;
}

int main(void) {
    char line[65536];
    while (fgets(line, sizeof(line), stdin)) {
        size_t len = strlen(line);
        while (len > 0 && (line[len - 1] == '\n' || line[len - 1] == '\r')) {
            line[--len] = '\0';
        }
        // skip blank lines but still try to parse (empty produces nothing meaningful)
        int hasContent = 0;
        for (size_t i = 0; i < len; i++) {
            if (!isspace((unsigned char)line[i])) { hasContent = 1; break; }
        }
        if (!hasContent) continue;
        p = line;
        long long result = parseExpr();
        printf("%lld\n", result);
    }
    return 0;
}
