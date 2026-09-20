import java.util.*;
import java.io.*;

public class Main {
    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        StreamTokenizer st = new StreamTokenizer(br);
        st.nextToken();
        int n = (int) st.nval;
        st.nextToken();
        int m = (int) st.nval;

        List<List<int[]>> adj = new ArrayList<>();
        for (int i = 0; i < n; i++) adj.add(new ArrayList<>());

        for (int i = 0; i < m; i++) {
            st.nextToken();
            int u = (int) st.nval;
            st.nextToken();
            int v = (int) st.nval;
            st.nextToken();
            int w = (int) st.nval;
            adj.get(u).add(new int[]{v, w});
            adj.get(v).add(new int[]{u, w});
        }

        st.nextToken();
        int s = (int) st.nval;
        st.nextToken();
        int t = (int) st.nval;

        long[] dist = new long[n];
        Arrays.fill(dist, Long.MAX_VALUE);
        dist[s] = 0;

        PriorityQueue<long[]> pq = new PriorityQueue<>((a, b) -> Long.compare(a[1], b[1]));
        pq.add(new long[]{s, 0});

        boolean[] visited = new boolean[n];

        while (!pq.isEmpty()) {
            long[] cur = pq.poll();
            int u = (int) cur[0];
            if (visited[u]) continue;
            visited[u] = true;
            if (u == t) break;
            for (int[] e : adj.get(u)) {
                int v = e[0];
                int w = e[1];
                if (!visited[v] && dist[u] + w < dist[v]) {
                    dist[v] = dist[u] + w;
                    pq.add(new long[]{v, dist[v]});
                }
            }
        }

        if (dist[t] == Long.MAX_VALUE) {
            System.out.println(-1);
        } else {
            System.out.println(dist[t]);
        }
    }
}
