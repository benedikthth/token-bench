#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

typedef struct { char *w; long c; } Ent;

static Ent *ents; static size_t n, cap;
static size_t *tab; static size_t tcap;

static unsigned long hash(const char *s) {
    unsigned long h = 1469598103934665603UL;
    while (*s) { h ^= (unsigned char)*s++; h *= 1099511628211UL; }
    return h;
}

static void rehash(void) {
    size_t nc = tcap ? tcap * 2 : 1024;
    size_t *nt = malloc(nc * sizeof *nt);
    for (size_t i = 0; i < nc; i++) nt[i] = (size_t)-1;
    for (size_t i = 0; i < n; i++) {
        size_t j = hash(ents[i].w) & (nc - 1);
        while (nt[j] != (size_t)-1) j = (j + 1) & (nc - 1);
        nt[j] = i;
    }
    free(tab); tab = nt; tcap = nc;
}

static void add(const char *w, size_t len) {
    if ((n + 1) * 2 > tcap) rehash();
    size_t j = hash(w) & (tcap - 1);
    while (tab[j] != (size_t)-1) {
        if (strcmp(ents[tab[j]].w, w) == 0) { ents[tab[j]].c++; return; }
        j = (j + 1) & (tcap - 1);
    }
    if (n == cap) { cap = cap ? cap * 2 : 1024; ents = realloc(ents, cap * sizeof *ents); }
    ents[n].w = malloc(len + 1); memcpy(ents[n].w, w, len + 1); ents[n].c = 1;
    tab[j] = n++;
}

static int cmp(const void *a, const void *b) {
    const Ent *x = a, *y = b;
    if (x->c != y->c) return x->c > y->c ? -1 : 1;
    return strcmp(x->w, y->w);
}

int main(void) {
    size_t bcap = 64, bl = 0;
    char *buf = malloc(bcap);
    int ch;
    rehash();
    for (;;) {
        ch = getchar();
        if (ch != EOF && ((ch >= 'a' && ch <= 'z') || (ch >= 'A' && ch <= 'Z'))) {
            if (bl + 1 >= bcap) { bcap *= 2; buf = realloc(buf, bcap); }
            buf[bl++] = (char)(ch | 0x20);
        } else {
            if (bl) { buf[bl] = 0; add(buf, bl); bl = 0; }
            if (ch == EOF) break;
        }
    }
    qsort(ents, n, sizeof *ents, cmp);
    for (size_t i = 0; i < n; i++) printf("%s %ld\n", ents[i].w, ents[i].c);
    return 0;
}
