#include <stdio.h>
#include <stdlib.h>

int main(void) {
    size_t cap = 1024, top = 0;
    char *st = malloc(cap);
    int ok = 1, pending = 0, c;
    while ((c = getchar()) != EOF) {
        if (c == '\n') {
            puts(ok && top == 0 ? "yes" : "no");
            top = 0; ok = 1; pending = 0;
            continue;
        }
        if (c == '\r') continue;
        pending = 1;
        if (!ok) continue;
        if (c == '(' || c == '[' || c == '{') {
            if (top == cap) { cap *= 2; st = realloc(st, cap); }
            st[top++] = (char)c;
        } else if (c == ')' || c == ']' || c == '}') {
            char want = c == ')' ? '(' : c == ']' ? '[' : '{';
            if (top == 0 || st[top - 1] != want) ok = 0;
            else top--;
        }
    }
    if (pending) puts(ok && top == 0 ? "yes" : "no");
    free(st);
    return 0;
}
