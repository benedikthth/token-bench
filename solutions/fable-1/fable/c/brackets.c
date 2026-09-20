#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(void) {
    size_t cap = 1024;
    char *stack = malloc(cap);
    if (!stack) return 1;
    size_t top = 0;
    int ok = 1;
    int have_line = 0;
    int c;

    while ((c = getchar()) != EOF) {
        if (c == '\n') {
            puts(ok && top == 0 ? "yes" : "no");
            top = 0;
            ok = 1;
            have_line = 0;
            continue;
        }
        if (c == '\r') continue;
        have_line = 1;
        if (!ok) continue;
        if (c == '(' || c == '[' || c == '{') {
            if (top == cap) {
                cap *= 2;
                char *n = realloc(stack, cap);
                if (!n) return 1;
                stack = n;
            }
            stack[top++] = (char)c;
        } else if (c == ')' || c == ']' || c == '}') {
            char want = c == ')' ? '(' : c == ']' ? '[' : '{';
            if (top == 0 || stack[top - 1] != want) ok = 0;
            else top--;
        } else {
            ok = 0;
        }
    }
    if (have_line) {
        puts(ok && top == 0 ? "yes" : "no");
    }
    free(stack);
    return 0;
}
