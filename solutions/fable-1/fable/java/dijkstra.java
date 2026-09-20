import java.io.*;
import java.util.*;

public class Main {
    public static void main(String[] args) throws IOException {
        DataInputStream in = new DataInputStream(new BufferedInputStream(System.in, 1 << 16));
        int n = nextInt(in);
        int m = nextInt(in);
        int[] head = new int[n];
        Arrays.fill(head, -1);
        int[] next = new int[2 * m];
        int[] to = new int[2 * m];
        long[] wt = new long[2 * m];
        int cnt = 0;
        for (int i = 0; i < m; i++) {
            int u = nextInt(in);
            int v = nextInt(in);
            long w = nextLong(in);
            to[cnt] = v; wt[cnt] = w; next[cnt] = head[u]; head[u] = cnt++;
            to[cnt] = u; wt[cnt] = w; next[cnt] = head[v]; head[v] = cnt++;
        }
        int s = nextInt(in);
        int t = nextInt(in);
        if (s == t) {
            System.out.println(0);
            return;
        }
        long[] dist = new long[n];
        Arrays.fill(dist, Long.MAX_VALUE);
        dist[s] = 0;
        PriorityQueue<long[]> pq = new PriorityQueue<>((a, b) -> Long.compare(a[0], b[0]));
        pq.add(new long[]{0, s});
        while (!pq.isEmpty()) {
            long[] cur = pq.poll();
            long d = cur[0];
            int u = (int) cur[1];
            if (d > dist[u]) continue;
            if (u == t) break;
            for (int e = head[u]; e != -1; e = next[e]) {
                int v = to[e];
                long nd = d + wt[e];
                if (nd < dist[v]) {
                    dist[v] = nd;
                    pq.add(new long[]{nd, v});
                }
            }
        }
        System.out.println(dist[t] == Long.MAX_VALUE ? -1 : dist[t]);
    }

    private static int nextInt(DataInputStream in) throws IOException {
        return (int) nextLong(in);
    }

    private static long nextLong(DataInputStream in) throws IOException {
        int b = in.read();
        while (b != -1 && b != '-' && (b < '0' || b > '9')) b = in.read();
        boolean neg = false;
        if (b == '-') { neg = true; b = in.read(); }
        long r = 0;
        while (b >= '0' && b <= '9') {
            r = r * 10 + (b - '0');
            b = in.read();
        }
        return neg ? -r : r;
    }
}
