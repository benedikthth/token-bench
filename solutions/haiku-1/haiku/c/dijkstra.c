#include <stdio.h>
#include <stdlib.h>
#include <limits.h>

#define INF INT_MAX

typedef struct {
    int* neighbors;
    int* weights;
    int count;
} AdjList;

int main() {
    int N, M;
    scanf("%d %d", &N, &M);

    // Create adjacency list for each node
    AdjList* graph = (AdjList*)malloc(N * sizeof(AdjList));
    for (int i = 0; i < N; i++) {
        graph[i].neighbors = (int*)malloc(2 * M * sizeof(int));
        graph[i].weights = (int*)malloc(2 * M * sizeof(int));
        graph[i].count = 0;
    }

    // Read edges
    for (int i = 0; i < M; i++) {
        int u, v, w;
        scanf("%d %d %d", &u, &v, &w);

        // Add u -> v
        graph[u].neighbors[graph[u].count] = v;
        graph[u].weights[graph[u].count] = w;
        graph[u].count++;

        // Add v -> u (undirected graph)
        graph[v].neighbors[graph[v].count] = u;
        graph[v].weights[graph[v].count] = w;
        graph[v].count++;
    }

    int s, t;
    scanf("%d %d", &s, &t);

    // Special case: start equals target
    if (s == t) {
        printf("0\n");
        return 0;
    }

    // Dijkstra's algorithm
    int* dist = (int*)malloc(N * sizeof(int));
    int* visited = (int*)malloc(N * sizeof(int));

    // Initialize distances and visited array
    for (int i = 0; i < N; i++) {
        dist[i] = INF;
        visited[i] = 0;
    }
    dist[s] = 0;

    // Process N nodes
    for (int i = 0; i < N; i++) {
        // Find unvisited node with minimum distance
        int u = -1;
        int minDist = INF;
        for (int j = 0; j < N; j++) {
            if (!visited[j] && dist[j] < minDist) {
                minDist = dist[j];
                u = j;
            }
        }

        // No more reachable nodes
        if (u == -1) break;

        visited[u] = 1;

        // Early exit if we reached the target
        if (u == t) break;

        // Relax edges from u to its neighbors
        for (int j = 0; j < graph[u].count; j++) {
            int v = graph[u].neighbors[j];
            int w = graph[u].weights[j];

            if (!visited[v] && dist[u] != INF && dist[u] + w < dist[v]) {
                dist[v] = dist[u] + w;
            }
        }
    }

    // Output result
    if (dist[t] == INF) {
        printf("-1\n");
    } else {
        printf("%d\n", dist[t]);
    }

    // Free memory
    for (int i = 0; i < N; i++) {
        free(graph[i].neighbors);
        free(graph[i].weights);
    }
    free(graph);
    free(dist);
    free(visited);

    return 0;
}
