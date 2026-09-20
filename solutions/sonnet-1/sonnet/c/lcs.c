#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static char *read_line(void) {
    size_t cap = 64;
    size_t len = 0;
    char *buf = malloc(cap);
    int c;
    int got = 0;

    while ((c = getchar()) != EOF) {
        got = 1;
        if (c == '\n') break;
        if (c == '\r') continue; /* tolerate CRLF */
        if (len + 1 >= cap) {
            cap *= 2;
            buf = realloc(buf, cap);
        }
        buf[len++] = (char)c;
    }

    if (!got && c == EOF) {
        free(buf);
        return NULL;
    }

    buf[len] = '\0';
    return buf;
}

int main(void) {
    char *a = read_line();
    char *b = read_line();
    if (!a) a = strdup("");
    if (!b) b = strdup("");

    size_t n = strlen(a);
    size_t m = strlen(b);

    int *prev = calloc(m + 1, sizeof(int));
    int *curr = calloc(m + 1, sizeof(int));

    for (size_t i = 1; i <= n; i++) {
        for (size_t j = 1; j <= m; j++) {
            if (a[i - 1] == b[j - 1]) {
                curr[j] = prev[j - 1] + 1;
            } else {
                curr[j] = prev[j] > curr[j - 1] ? prev[j] : curr[j - 1];
            }
        }
        int *tmp = prev;
        prev = curr;
        curr = tmp;
    }

    printf("%d\n", prev[m]);

    free(a);
    free(b);
    free(prev);
    free(curr);
    return 0;
}
