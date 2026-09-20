import java.io.*;
import java.util.*;

public class Main {
    public static void main(String[] args) throws IOException {
        DataInputStream in = new DataInputStream(new BufferedInputStream(System.in, 1 << 16));
        int r = nextInt(in);
        int c = nextInt(in);
        long[][] a = new long[r][c];
        for (int i = 0; i < r; i++) {
            for (int j = 0; j < c; j++) {
                a[i][j] = nextLong(in);
            }
        }
        StringBuilder sb = new StringBuilder();
        for (int j = 0; j < c; j++) {
            for (int i = 0; i < r; i++) {
                if (i > 0) sb.append(' ');
                sb.append(a[i][j]);
            }
            sb.append('\n');
        }
        PrintWriter out = new PrintWriter(new BufferedWriter(new OutputStreamWriter(System.out)));
        out.print(sb);
        out.flush();
    }

    private static int nextInt(DataInputStream in) throws IOException {
        return (int) nextLong(in);
    }

    private static long nextLong(DataInputStream in) throws IOException {
        int b = in.read();
        while (b != -1 && b != '-' && (b < '0' || b > '9')) b = in.read();
        if (b == -1) return 0;
        boolean neg = false;
        if (b == '-') {
            neg = true;
            b = in.read();
        }
        long val = 0;
        while (b >= '0' && b <= '9') {
            val = val * 10 + (b - '0');
            b = in.read();
        }
        return neg ? -val : val;
    }
}
