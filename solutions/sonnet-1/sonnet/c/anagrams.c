#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    char *word;
    char *key;
} Item;

typedef struct {
    int start;
    int end; /* exclusive */
} Group;

static int cmp_items(const void *a, const void *b) {
    const Item *ia = (const Item *)a;
    const Item *ib = (const Item *)b;
    int c = strcmp(ia->key, ib->key);
    if (c != 0) return c;
    return strcmp(ia->word, ib->word);
}

static int cmp_groups(const void *a, const void *b) {
    const Group *ga = (const Group *)a;
    const Group *gb = (const Group *)b;
    extern Item *g_items;
    return strcmp(g_items[ga->start].word, g_items[gb->start].word);
}

Item *g_items = NULL;

int main(void) {
    size_t cap = 1024;
    size_t n = 0;
    Item *items = malloc(cap * sizeof(Item));
    if (!items) return 1;

    char *line = NULL;
    size_t linecap = 0;
    ssize_t len;

    while ((len = getline(&line, &linecap, stdin)) != -1) {
        /* strip trailing newline / carriage return */
        while (len > 0 && (line[len - 1] == '\n' || line[len - 1] == '\r')) {
            line[len - 1] = '\0';
            len--;
        }
        if (len == 0) continue;

        if (n == cap) {
            cap *= 2;
            items = realloc(items, cap * sizeof(Item));
            if (!items) return 1;
        }

        char *word = malloc((size_t)len + 1);
        memcpy(word, line, (size_t)len + 1);

        char *key = malloc((size_t)len + 1);
        memcpy(key, line, (size_t)len + 1);

        items[n].word = word;
        items[n].key = key;
        n++;
    }
    free(line);

    /* sort each key's characters (simple insertion sort, words are short) */
    for (size_t i = 0; i < n; i++) {
        char *k = items[i].key;
        size_t klen = strlen(k);
        for (size_t x = 1; x < klen; x++) {
            char v = k[x];
            size_t y = x;
            while (y > 0 && k[y - 1] > v) {
                k[y] = k[y - 1];
                y--;
            }
            k[y] = v;
        }
    }

    g_items = items;
    qsort(items, n, sizeof(Item), cmp_items);

    if (n == 0) {
        free(items);
        return 0;
    }

    /* build groups */
    size_t gcap = 64;
    size_t gcount = 0;
    Group *groups = malloc(gcap * sizeof(Group));
    size_t start = 0;
    for (size_t i = 1; i <= n; i++) {
        if (i == n || strcmp(items[i].key, items[start].key) != 0) {
            if (gcount == gcap) {
                gcap *= 2;
                groups = realloc(groups, gcap * sizeof(Group));
            }
            groups[gcount].start = (int)start;
            groups[gcount].end = (int)i;
            gcount++;
            start = i;
        }
    }

    qsort(groups, gcount, sizeof(Group), cmp_groups);

    for (size_t g = 0; g < gcount; g++) {
        for (int i = groups[g].start; i < groups[g].end; i++) {
            if (i > groups[g].start) fputc(' ', stdout);
            fputs(items[i].word, stdout);
        }
        fputc('\n', stdout);
    }

    for (size_t i = 0; i < n; i++) {
        free(items[i].word);
        free(items[i].key);
    }
    free(items);
    free(groups);

    return 0;
}
