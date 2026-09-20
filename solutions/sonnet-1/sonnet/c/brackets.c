#include <stdio.h>
#include <stdlib.h>

int main(void) {
    size_t cap = 1024;
    char *stack = (char *)malloc(cap);
    long sp = 0;
    int c;
    int line_started = 0;
    int error = 0;

    if (!stack) return 1;

    while (1) {
        c = getchar();
        if (c == '\n') {
            printf("%s\n", (!error && sp == 0) ? "yes" : "no");
            sp = 0;
            line_started = 0;
            error = 0;
            continue;
        }
        if (c == EOF) {
            if (line_started) {
                printf("%s\n", (!error && sp == 0) ? "yes" : "no");
            }
            break;
        }

        line_started = 1;
        switch (c) {
            case '(': case '[': case '{':
                if ((size_t)sp >= cap) {
                    cap *= 2;
                    stack = (char *)realloc(stack, cap);
                    if (!stack) return 1;
                }
                stack[sp++] = (char)c;
                break;
            case ')':
                if (error || sp == 0 || stack[sp - 1] != '(') error = 1; else sp--;
                break;
            case ']':
                if (error || sp == 0 || stack[sp - 1] != '[') error = 1; else sp--;
                break;
            case '}':
                if (error || sp == 0 || stack[sp - 1] != '{') error = 1; else sp--;
                break;
            default:
                break;
        }
    }

    free(stack);
    return 0;
}
