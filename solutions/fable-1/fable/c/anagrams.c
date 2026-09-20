#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    char *word;
    char *key;
} Entry;

typedef struct {
    size_t start;
    size_t count;
} Group;

static Entry *entries = NULL;
static size_t n_entries = 0, cap_entries = 0;

static int cmp_char(const void *a, const void *b) {
    return (int)(*(const unsigned char *)a) - (int)(*(const unsigned char *)b);
}

static int cmp_entry(const void *a, const void *b) {
    const Entry *x = a, *y = b;
    int c = strcmp(x->key, y->key);
    if (c) return c;
    return strcmp(x->word, y->word);
}

static int cmp_group(const void *a, const void *b) {
    const Group *x = a, *y = b;
    return strcmp(entries[x->start].word, entries[y->start].word);
}

static void add_entry(const char *s, size_t len) {
    if (n_entries == cap_entries) {
        cap_entries = cap_entries ? cap_entries * 2 : 1024;
        entries = realloc(entries, cap_entries * sizeof(Entry));
        if (!entries) exit(1);
    }
    char *w = malloc(len + 1);
    char *k = malloc(len + 1);
    if (!w || !k) exit(1);
    memcpy(w, s, len);
    w[len] = '\0';
    memcpy(k, s, len);
    k[len] = '\0';
    qsort(k, len, 1, cmp_char);
    entries[n_entries].word = w;
    entries[n_entries].key = k;
    n_entries++;
}

int main(void) {
    char *line = NULL;
    size_t lcap = 0;
    ssize_t len;
    while ((len = getline(&line, &lcap, stdin)) != -1) {
        while (len > 0 && (line[len - 1] == '\n' || line[len - 1] == '\r'))
            len--;
        if (len == 0) continue;
        add_entry(line, (size_t)len);
    }
    free(line);

    if (n_entries == 0) return 0;

    qsort(entries, n_entries, sizeof(Entry), cmp_entry);

    Group *groups = malloc(n_entries * sizeof(Group));
    if (!groups) exit(1);
    size_t n_groups = 0;
    size_t i = 0;
    while (i < n_entries) {
        size_t j = i + 1;
        while (j < n_entries && strcmp(entries[j].key, entries[i].key) == 0)
            j++;
        groups[n_groups].start = i;
        groups[n_groups].count = j - i;
        n_groups++;
        i = j;
    }

    qsort(groups, n_groups, sizeof(Group), cmp_group);

    for (size_t g = 0; g < n_groups; g++) {
        for (size_t k = 0; k < groups[g].count; k++) {
            if (k) putchar(' ');
            fputs(entries[groups[g].start + k].word, stdout);
        }
        putchar('\n');
    }
    return 0;
}
