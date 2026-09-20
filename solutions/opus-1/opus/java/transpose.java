import java.io.*;

public class Main {
    static byte[] buf;
    static int pos, len;

    static long next() {
        while (pos < len && (buf[pos] < '0' || buf[pos] > '9') && buf[pos] != '-') pos++;
        boolean neg = false;
        if (pos < len && buf[pos] == '-') { neg = true; pos++; }
        long v = 0;
        while (pos < len && buf[pos] >= '0' && buf[pos] <= '9') { v = v * 10 + (buf[pos] - '0'); pos++; }
        return neg ? -v : v;
    }

    public static void main(String[] args) throws IOException {
        buf = System.in.readAllBytes();
        len = buf.length;
        int r = (int) next(), c = (int) next();
        long[][] m = new long[r][c];
        for (int i = 0; i < r; i++)
            for (int j = 0; j < c; j++)
                m[i][j] = next();
        StringBuilder sb = new StringBuilder();
        for (int j = 0; j < c; j++) {
            for (int i = 0; i < r; i++) {
                if (i > 0) sb.append(' ');
                sb.append(m[i][j]);
            }
            sb.append('\n');
        }
        PrintStream out = new PrintStream(new BufferedOutputStream(System.out), false);
        out.print(sb);
        out.flush();
    }
}
