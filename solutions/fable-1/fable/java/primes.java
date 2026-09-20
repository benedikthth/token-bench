import java.io.*;
import java.util.*;

public class Main {
    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        StringBuilder in = new StringBuilder();
        String line;
        while ((line = br.readLine()) != null) {
            in.append(line).append(' ');
        }
        String s = in.toString().trim();
        int n = s.isEmpty() ? 0 : Integer.parseInt(s.split("\\s+")[0]);

        boolean[] composite = new boolean[Math.max(n + 1, 2)];
        StringBuilder out = new StringBuilder();
        boolean first = true;
        for (int i = 2; i <= n; i++) {
            if (!composite[i]) {
                if (!first) out.append(' ');
                out.append(i);
                first = false;
                for (long j = (long) i * i; j <= n; j += i) {
                    composite[(int) j] = true;
                }
            }
        }
        out.append('\n');
        PrintWriter pw = new PrintWriter(new BufferedWriter(new OutputStreamWriter(System.out)));
        pw.print(out);
        pw.flush();
    }
}
