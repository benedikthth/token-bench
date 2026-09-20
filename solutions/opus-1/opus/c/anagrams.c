#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct { char *word; char *key; } Item;
typedef struct { size_t start, len; } Group;

static Item *items;

static int cmpchar(const void *a, const void *b) {
    return *(const unsigned char *)a - *(const unsigned char *)b;
}

static int cmpitem(const void *a, const void *b) {
    const Item *x = a, *y = b;
    int c = strcmp(x->key, y->key);
    return c ? c : strcmp(x->word, y->word);
}

static int cmpgroup(const void *a, const void *b) {
    const Group *x = a, *y = b;
    return strcmp(items[x->start].word, items[y->start].word);
}

int main(void) {
    size_t cap = 1024, n = 0;
    items = malloc(cap * sizeof *items);
    char *line = NULL;
    size_t lcap = 0;
    ssize_t len;
    while ((len = getline(&line, &lcap, stdin)) != -1) {
        while (len > 0 && (line[len - 1] == '\n' || line[len - 1] == '\r' ||
                           line[len - 1] == ' ' || line[len - 1] == '\t'))
            line[--len] = '\0';
        char *s = line;
        while (*s == ' ' || *s == '\t') { s++; len--; }
        if (len <= 0) continue;
        if (n == cap) { cap *= 2; items = realloc(items, cap * sizeof *items); }
        items[n].word = malloc(len + 1);
        memcpy(items[n].word, s, len + 1);
        items[n].key = malloc(len + 1);
        memcpy(items[n].key, s, len + 1);
        qsort(items[n].key, len, 1, cmpchar);
        n++;
    }
    free(line);
    if (n == 0) return 0;

    qsort(items, n, sizeof *items, cmpitem);

    Group *groups = malloc(n * sizeof *groups);
    size_t g = 0;
    for (size_t i = 0; i < n;) {
        size_t j = i + 1;
        while (j < n && strcmp(items[j].key, items[i].key) == 0) j++;
        groups[g].start = i;
        groups[g].len = j - i;
        g++;
        i = j;
    }
    qsort(groups, g, sizeof *groups, cmpgroup);

    for (size_t k = 0; k < g; k++) {
        for (size_t i = 0; i < groups[k].len; i++) {
            if (i) putchar(' ');
            fputs(items[groups[k].start + i].word, stdout);
        }
        putchar('\n');
    }
    return 0;
}
