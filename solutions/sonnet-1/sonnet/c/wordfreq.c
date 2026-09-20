#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

typedef struct {
    char *word;
    long count;
} Entry;

#define INIT_CAP 1024

static Entry *table = NULL;
static size_t cap = 0;
static size_t used = 0;

static unsigned long hash_str(const char *s) {
    unsigned long h = 5381;
    int c;
    while ((c = (unsigned char)*s++)) {
        h = ((h << 5) + h) + (unsigned long)c;
    }
    return h;
}

static void table_init(size_t initial_cap) {
    cap = initial_cap;
    table = calloc(cap, sizeof(Entry));
    used = 0;
}

static void table_grow(void);

static void table_insert(const char *word) {
    if (used * 2 >= cap) {
        table_grow();
    }
    unsigned long h = hash_str(word);
    size_t idx = h % cap;
    while (table[idx].word != NULL) {
        if (strcmp(table[idx].word, word) == 0) {
            table[idx].count++;
            return;
        }
        idx = (idx + 1) % cap;
    }
    table[idx].word = strdup(word);
    table[idx].count = 1;
    used++;
}

static void table_grow(void) {
    size_t old_cap = cap;
    Entry *old_table = table;
    cap = cap * 2;
    table = calloc(cap, sizeof(Entry));
    used = 0;
    for (size_t i = 0; i < old_cap; i++) {
        if (old_table[i].word != NULL) {
            unsigned long h = hash_str(old_table[i].word);
            size_t idx = h % cap;
            while (table[idx].word != NULL) {
                idx = (idx + 1) % cap;
            }
            table[idx].word = old_table[i].word;
            table[idx].count = old_table[i].count;
            used++;
        }
    }
    free(old_table);
}

static int cmp_entry(const void *a, const void *b) {
    const Entry *ea = (const Entry *)a;
    const Entry *eb = (const Entry *)b;
    if (ea->count != eb->count) {
        return (ea->count < eb->count) ? 1 : -1;
    }
    return strcmp(ea->word, eb->word);
}

int main(void) {
    table_init(INIT_CAP);

    char buf[256];
    size_t len = 0;
    int c;

    while ((c = getchar()) != EOF) {
        if (c >= 'A' && c <= 'Z') {
            c = c - 'A' + 'a';
        }
        if (c >= 'a' && c <= 'z') {
            if (len + 1 < sizeof(buf)) {
                buf[len++] = (char)c;
            }
        } else {
            if (len > 0) {
                buf[len] = '\0';
                table_insert(buf);
                len = 0;
            }
        }
    }
    if (len > 0) {
        buf[len] = '\0';
        table_insert(buf);
    }

    Entry *results = malloc(used * sizeof(Entry));
    size_t ri = 0;
    for (size_t i = 0; i < cap; i++) {
        if (table[i].word != NULL) {
            results[ri++] = table[i];
        }
    }

    qsort(results, ri, sizeof(Entry), cmp_entry);

    for (size_t i = 0; i < ri; i++) {
        printf("%s %ld\n", results[i].word, results[i].count);
    }

    return 0;
}
