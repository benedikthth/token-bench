#include <stdio.h>
#include <stdlib.h>

typedef struct { int to; long long w; int next; } Edge;
typedef struct { long long d; int v; } Item;

static Item *heap; static int hsz;

static void push(Item x) {
    int i = hsz++;
    heap[i] = x;
    while (i > 0) {
        int p = (i - 1) / 2;
        if (heap[p].d <= heap[i].d) break;
        Item t = heap[p]; heap[p] = heap[i]; heap[i] = t;
        i = p;
    }
}

static Item pop(void) {
    Item r = heap[0];
    heap[0] = heap[--hsz];
    int i = 0;
    for (;;) {
        int l = 2 * i + 1, rr = l + 1, m = i;
        if (l < hsz && heap[l].d < heap[m].d) m = l;
        if (rr < hsz && heap[rr].d < heap[m].d) m = rr;
        if (m == i) break;
        Item t = heap[m]; heap[m] = heap[i]; heap[i] = t;
        i = m;
    }
    return r;
}

int main(void) {
    int n, m;
    if (scanf("%d %d", &n, &m) != 2) return 0;
    if (n < 1) n = 1;
    int *head = malloc(sizeof(int) * n);
    for (int i = 0; i < n; i++) head[i] = -1;
    Edge *edges = malloc(sizeof(Edge) * (2 * (size_t)m + 2));
    int ec = 0;
    for (int i = 0; i < m; i++) {
        int u, v; long long w;
        if (scanf("%d %d %lld", &u, &v, &w) != 3) break;
        if (u < 0 || u >= n || v < 0 || v >= n) continue;
        edges[ec].to = v; edges[ec].w = w; edges[ec].next = head[u]; head[u] = ec++;
        edges[ec].to = u; edges[ec].w = w; edges[ec].next = head[v]; head[v] = ec++;
    }
    int s, t;
    if (scanf("%d %d", &s, &t) != 2) return 0;
    if (s == t) { printf("0\n"); return 0; }
    if (s < 0 || s >= n || t < 0 || t >= n) { printf("-1\n"); return 0; }
    const long long INF = 0x3f3f3f3f3f3f3f3fLL;
    long long *dist = malloc(sizeof(long long) * n);
    char *done = calloc(n, 1);
    for (int i = 0; i < n; i++) dist[i] = INF;
    heap = malloc(sizeof(Item) * (ec + 2));
    hsz = 0;
    dist[s] = 0;
    push((Item){0, s});
    while (hsz > 0) {
        Item it = pop();
        if (done[it.v]) continue;
        done[it.v] = 1;
        if (it.v == t) break;
        for (int e = head[it.v]; e != -1; e = edges[e].next) {
            int v = edges[e].to;
            long long nd = it.d + edges[e].w;
            if (nd < dist[v]) { dist[v] = nd; push((Item){nd, v}); }
        }
    }
    if (dist[t] >= INF) printf("-1\n"); else printf("%lld\n", dist[t]);
    return 0;
}
