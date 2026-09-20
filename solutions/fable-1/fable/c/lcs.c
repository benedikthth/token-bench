#include <stdio.h>
#include <string.h>

#define MAXN 4100

static char a[MAXN], b[MAXN];
static int prev_row[MAXN], cur_row[MAXN];

static int read_line(char *buf, int size) {
    if (fgets(buf, size, stdin) == NULL) {
        buf[0] = '\0';
        return 0;
    }
    int len = (int)strlen(buf);
    while (len > 0 && (buf[len - 1] == '\n' || buf[len - 1] == '\r'))
        buf[--len] = '\0';
    return len;
}

int main(void) {
    int n = read_line(a, MAXN);
    int m = read_line(b, MAXN);

    for (int j = 0; j <= m; j++) prev_row[j] = 0;

    for (int i = 1; i <= n; i++) {
        cur_row[0] = 0;
        for (int j = 1; j <= m; j++) {
            if (a[i - 1] == b[j - 1])
                cur_row[j] = prev_row[j - 1] + 1;
            else
                cur_row[j] = prev_row[j] > cur_row[j - 1] ? prev_row[j] : cur_row[j - 1];
        }
        memcpy(prev_row, cur_row, (size_t)(m + 1) * sizeof(int));
    }

    printf("%d\n", prev_row[m]);
    return 0;
}
