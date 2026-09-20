import java.util.*;

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);

        // Read N (number of nodes) and M (number of edges)
        int N = sc.nextInt();
        int M = sc.nextInt();

        // Build adjacency list for the graph
        List<List<int[]>> graph = new ArrayList<>();
        for (int i = 0; i < N; i++) {
            graph.add(new ArrayList<>());
        }

        // Read M edges
        for (int i = 0; i < M; i++) {
            int u = sc.nextInt();
            int v = sc.nextInt();
            int w = sc.nextInt();
            // Undirected graph: add edge in both directions
            graph.get(u).add(new int[]{v, w});
            graph.get(v).add(new int[]{u, w});
        }

        // Read start and target nodes
        int s = sc.nextInt();
        int t = sc.nextInt();

        // Special case: start equals target
        if (s == t) {
            System.out.println(0);
            return;
        }

        // Dijkstra's algorithm
        long[] dist = new long[N];
        Arrays.fill(dist, Long.MAX_VALUE);
        dist[s] = 0;

        // Priority queue: stores [distance, node]
        PriorityQueue<long[]> pq = new PriorityQueue<>((a, b) -> Long.compare(a[0], b[0]));
        pq.add(new long[]{0, s});

        while (!pq.isEmpty()) {
            long[] curr = pq.poll();
            long d = curr[0];
            int u = (int) curr[1];

            // Skip if we've already found a better path
            if (d > dist[u]) continue;

            // Relax edges
            for (int[] edge : graph.get(u)) {
                int v = edge[0];
                int w = edge[1];

                if (dist[u] + w < dist[v]) {
                    dist[v] = dist[u] + w;
                    pq.add(new long[]{dist[v], v});
                }
            }
        }

        // Output result
        if (dist[t] == Long.MAX_VALUE) {
            System.out.println(-1);
        } else {
            System.out.println(dist[t]);
        }
    }
}
