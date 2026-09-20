#include <stdio.h>
#include <stdlib.h>
#include <limits.h>

typedef struct {
    int to;
    long long w;
    int next;
} Edge;

int main(void) {
    int n, m;
    if (scanf("%d %d", &n, &m) != 2) return 0;

    int *head = malloc(sizeof(int) * (n > 0 ? n : 1));
    for (int i = 0; i < n; i++) head[i] = -1;

    Edge *edges = malloc(sizeof(Edge) * (size_t)(2 * m > 0 ? 2 * m : 1));
    int edgeCount = 0;

    for (int i = 0; i < m; i++) {
        int u, v;
        long long w;
        scanf("%d %d %lld", &u, &v, &w);
        edges[edgeCount].to = v;
        edges[edgeCount].w = w;
        edges[edgeCount].next = head[u];
        head[u] = edgeCount++;

        edges[edgeCount].to = u;
        edges[edgeCount].w = w;
        edges[edgeCount].next = head[v];
        head[v] = edgeCount++;
    }

    int s, t;
    scanf("%d %d", &s, &t);

    if (s == t) {
        printf("0\n");
        free(head);
        free(edges);
        return 0;
    }

    long long *dist = malloc(sizeof(long long) * (n > 0 ? n : 1));
    char *visited = calloc((size_t)(n > 0 ? n : 1), 1);
    for (int i = 0; i < n; i++) dist[i] = LLONG_MAX;
    dist[s] = 0;

    // simple binary heap priority queue (worst case: one push per relaxation attempt, plus the initial push)
    size_t heapCap = (size_t)(2 * m) + 2;
    int *heapNode = malloc(sizeof(int) * heapCap);
    long long *heapDist = malloc(sizeof(long long) * heapCap);
    int heapSize = 0;

    // push initial
    heapNode[heapSize] = s;
    heapDist[heapSize] = 0;
    heapSize++;

    while (heapSize > 0) {
        // pop min
        long long topDist = heapDist[0];
        int topNode = heapNode[0];
        heapSize--;
        heapDist[0] = heapDist[heapSize];
        heapNode[0] = heapNode[heapSize];
        int idx = 0;
        while (1) {
            int left = 2 * idx + 1;
            int right = 2 * idx + 2;
            int smallest = idx;
            if (left < heapSize && heapDist[left] < heapDist[smallest]) smallest = left;
            if (right < heapSize && heapDist[right] < heapDist[smallest]) smallest = right;
            if (smallest == idx) break;
            long long td = heapDist[idx]; heapDist[idx] = heapDist[smallest]; heapDist[smallest] = td;
            int tn = heapNode[idx]; heapNode[idx] = heapNode[smallest]; heapNode[smallest] = tn;
            idx = smallest;
        }

        if (visited[topNode]) continue;
        visited[topNode] = 1;

        if (topNode == t) break;

        for (int e = head[topNode]; e != -1; e = edges[e].next) {
            int to = edges[e].to;
            long long nd = topDist + edges[e].w;
            if (!visited[to] && nd < dist[to]) {
                dist[to] = nd;
                // push
                if ((size_t)heapSize >= heapCap) {
                    heapCap *= 2;
                    heapNode = realloc(heapNode, sizeof(int) * heapCap);
                    heapDist = realloc(heapDist, sizeof(long long) * heapCap);
                }
                int i2 = heapSize;
                heapDist[i2] = nd;
                heapNode[i2] = to;
                heapSize++;
                while (i2 > 0) {
                    int parent = (i2 - 1) / 2;
                    if (heapDist[parent] > heapDist[i2]) {
                        long long td = heapDist[parent]; heapDist[parent] = heapDist[i2]; heapDist[i2] = td;
                        int tn = heapNode[parent]; heapNode[parent] = heapNode[i2]; heapNode[i2] = tn;
                        i2 = parent;
                    } else break;
                }
            }
        }
    }

    if (dist[t] == LLONG_MAX) {
        printf("-1\n");
    } else {
        printf("%lld\n", dist[t]);
    }

    free(head);
    free(edges);
    free(dist);
    free(visited);
    free(heapNode);
    free(heapDist);
    return 0;
}
