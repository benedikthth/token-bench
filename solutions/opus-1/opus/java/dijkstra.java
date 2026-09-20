import java.io.*;
import java.util.*;

public class Main {
    public static void main(String[] args) throws IOException {
        DataInputStream in = new DataInputStream(new BufferedInputStream(System.in, 1 << 16));
        int n = (int) next(in), m = (int) next(in);
        int[] head = new int[Math.max(n, 1)];
        Arrays.fill(head, -1);
        int[] nxt = new int[2 * m], to = new int[2 * m];
        long[] wt = new long[2 * m];
        int e = 0;
        for (int i = 0; i < m; i++) {
            int u = (int) next(in), v = (int) next(in);
            long w = next(in);
            to[e] = v; wt[e] = w; nxt[e] = head[u]; head[u] = e++;
            to[e] = u; wt[e] = w; nxt[e] = head[v]; head[v] = e++;
        }
        int s = (int) next(in), t = (int) next(in);
        if (s == t) { System.out.println(0); return; }
        long[] dist = new long[n];
        Arrays.fill(dist, Long.MAX_VALUE);
        dist[s] = 0;
        PriorityQueue<long[]> pq = new PriorityQueue<>((a, b) -> Long.compare(a[0], b[0]));
        pq.add(new long[]{0, s});
        while (!pq.isEmpty()) {
            long[] cur = pq.poll();
            int u = (int) cur[1];
            if (cur[0] > dist[u]) continue;
            if (u == t) break;
            for (int k = head[u]; k != -1; k = nxt[k]) {
                long nd = cur[0] + wt[k];
                if (nd < dist[to[k]]) {
                    dist[to[k]] = nd;
                    pq.add(new long[]{nd, to[k]});
                }
            }
        }
        System.out.println(dist[t] == Long.MAX_VALUE ? -1 : dist[t]);
    }

    private static long next(DataInputStream in) throws IOException {
        int c = in.read();
        while (c != '-' && (c < '0' || c > '9')) c = in.read();
        boolean neg = c == '-';
        if (neg) c = in.read();
        long r = 0;
        while (c >= '0' && c <= '9') { r = r * 10 + (c - '0'); c = in.read(); }
        return neg ? -r : r;
    }
}
