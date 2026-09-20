#include <stdio.h>
#include <stdlib.h>

typedef struct { long long d; int v; } Item;

static Item *heap;
static int hsz;

static void push(long long d, int v) {
    int i = hsz++;
    while (i > 0) {
        int p = (i - 1) / 2;
        if (heap[p].d <= d) break;
        heap[i] = heap[p];
        i = p;
    }
    heap[i].d = d;
    heap[i].v = v;
}

static Item pop(void) {
    Item top = heap[0];
    Item last = heap[--hsz];
    int i = 0;
    for (;;) {
        int c = 2 * i + 1;
        if (c >= hsz) break;
        if (c + 1 < hsz && heap[c + 1].d < heap[c].d) c++;
        if (heap[c].d >= last.d) break;
        heap[i] = heap[c];
        i = c;
    }
    if (hsz > 0) heap[i] = last;
    return top;
}

int main(void) {
    int n, m;
    if (scanf("%d %d", &n, &m) != 2) return 0;
    if (n < 1) n = 1;
    int *eu = malloc(sizeof(int) * (m > 0 ? m : 1));
    int *ev = malloc(sizeof(int) * (m > 0 ? m : 1));
    long long *ew = malloc(sizeof(long long) * (m > 0 ? m : 1));
    int *deg = calloc(n + 1, sizeof(int));
    int cnt = 0;
    for (int i = 0; i < m; i++) {
        int u, v;
        long long w;
        if (scanf("%d %d %lld", &u, &v, &w) != 3) break;
        if (u < 0 || u >= n || v < 0 || v >= n) continue;
        eu[cnt] = u; ev[cnt] = v; ew[cnt] = w; cnt++;
        deg[u]++; deg[v]++;
    }
    int s, t;
    if (scanf("%d %d", &s, &t) != 2) return 0;
    if (s == t) { printf("0\n"); return 0; }
    if (s < 0 || s >= n || t < 0 || t >= n) { printf("-1\n"); return 0; }

    int *start = malloc(sizeof(int) * (n + 1));
    start[0] = 0;
    for (int i = 0; i < n; i++) start[i + 1] = start[i] + deg[i];
    int *pos = malloc(sizeof(int) * (n + 1));
    for (int i = 0; i <= n; i++) pos[i] = start[i];
    int tot = 2 * cnt;
    int *adj = malloc(sizeof(int) * (tot > 0 ? tot : 1));
    long long *aw = malloc(sizeof(long long) * (tot > 0 ? tot : 1));
    for (int i = 0; i < cnt; i++) {
        adj[pos[eu[i]]] = ev[i]; aw[pos[eu[i]]++] = ew[i];
        adj[pos[ev[i]]] = eu[i]; aw[pos[ev[i]]++] = ew[i];
    }

    long long *dist = malloc(sizeof(long long) * n);
    char *done = calloc(n, 1);
    for (int i = 0; i < n; i++) dist[i] = -1;
    heap = malloc(sizeof(Item) * (tot + 2));
    dist[s] = 0;
    push(0, s);
    while (hsz > 0) {
        Item it = pop();
        int u = it.v;
        if (done[u]) continue;
        done[u] = 1;
        if (u == t) break;
        for (int k = start[u]; k < start[u + 1]; k++) {
            int v = adj[k];
            long long nd = it.d + aw[k];
            if (!done[v] && (dist[v] < 0 || nd < dist[v])) {
                dist[v] = nd;
                push(nd, v);
            }
        }
    }
    printf("%lld\n", dist[t]);
    return 0;
}
