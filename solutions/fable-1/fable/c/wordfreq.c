#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct Entry {
    char *word;
    long count;
    struct Entry *next;
} Entry;

static Entry **table;
static size_t tsize = 1 << 16;
static size_t nentries = 0;
static Entry **all;
static size_t allcap = 0;

static unsigned long hash_str(const char *s) {
    unsigned long h = 1469598103934665603UL;
    while (*s) {
        h ^= (unsigned char)*s++;
        h *= 1099511628211UL;
    }
    return h;
}

static void rehash(void) {
    size_t nsize = tsize * 2;
    Entry **nt = calloc(nsize, sizeof(Entry *));
    if (!nt) exit(1);
    for (size_t i = 0; i < tsize; i++) {
        Entry *e = table[i];
        while (e) {
            Entry *nx = e->next;
            size_t idx = hash_str(e->word) & (nsize - 1);
            e->next = nt[idx];
            nt[idx] = e;
            e = nx;
        }
    }
    free(table);
    table = nt;
    tsize = nsize;
}

static void add_word(const char *w) {
    size_t idx = hash_str(w) & (tsize - 1);
    for (Entry *e = table[idx]; e; e = e->next) {
        if (strcmp(e->word, w) == 0) {
            e->count++;
            return;
        }
    }
    Entry *e = malloc(sizeof(Entry));
    if (!e) exit(1);
    e->word = strdup(w);
    if (!e->word) exit(1);
    e->count = 1;
    e->next = table[idx];
    table[idx] = e;
    if (nentries == allcap) {
        allcap = allcap ? allcap * 2 : 1024;
        all = realloc(all, allcap * sizeof(Entry *));
        if (!all) exit(1);
    }
    all[nentries++] = e;
    if (nentries > tsize * 3 / 4) rehash();
}

static int cmp(const void *a, const void *b) {
    const Entry *x = *(const Entry *const *)a;
    const Entry *y = *(const Entry *const *)b;
    if (x->count != y->count) return x->count > y->count ? -1 : 1;
    return strcmp(x->word, y->word);
}

int main(void) {
    table = calloc(tsize, sizeof(Entry *));
    if (!table) exit(1);

    char *buf = NULL;
    size_t cap = 0, len = 0;
    int c;
    while ((c = getchar()) != EOF) {
        int is_alpha = (c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z');
        if (is_alpha) {
            if (c >= 'A' && c <= 'Z') c += 'a' - 'A';
            if (len + 1 >= cap) {
                cap = cap ? cap * 2 : 64;
                buf = realloc(buf, cap);
                if (!buf) exit(1);
            }
            buf[len++] = (char)c;
        } else if (len > 0) {
            buf[len] = '\0';
            add_word(buf);
            len = 0;
        }
    }
    if (len > 0) {
        buf[len] = '\0';
        add_word(buf);
    }

    qsort(all, nentries, sizeof(Entry *), cmp);
    for (size_t i = 0; i < nentries; i++)
        printf("%s %ld\n", all[i]->word, all[i]->count);
    return 0;
}
